# One colorway on an SPO (an SPO line). Carries the units ordered, the delivery
# dates, and its own cost sheet (cost groups and costs).
class ColorwayItem < ApplicationRecord
  include ColorwayItemStateMachine
  include EventLoggable

  self.logged_state_attribute = :cost_sheet_state

  STATUSES = %w[active canceled].freeze

  belongs_to :style_purchase_order, inverse_of: :colorway_items
  belongs_to :colorway_style
  has_many :cost_groups, dependent: :destroy
  has_many :costs, through: :cost_groups
  has_many :materials, dependent: :destroy
  has_many :reservations, through: :materials

  scope :active, -> { where(status: "active") }
  scope :upcoming, lambda {
    where("COALESCE(revised_delivery_date, original_delivery_date) >= ?", Date.current)
  }

  validates :status, inclusion: { in: STATUSES }
  validates :units_requested, numericality: { greater_than_or_equal_to: 0 }

  before_save :set_extended_cost
  after_save :recalculate_purchase_order_totals, if: :saved_change_affecting_totals?
  after_destroy :recalculate_purchase_order_totals

  def canceled?
    status == "canceled"
  end

  def delivery_date
    revised_delivery_date || original_delivery_date
  end

  # The actual landed cost per unit. Cost sheet values are estimates until the
  # cost sheet is locked; locking is what turns them into actuals.
  def actual_cost_per_unit_cents
    return unless cost_sheet_locked?

    cost_groups.sum(&:extended_value_sum_cents)
  end

  # Keeps the unit cost in sync with the cost sheet until the sheet is locked.
  # After that, unit_cost_cents is a snapshot and must not move.
  def refresh_unit_cost!
    return if cost_sheet_locked?

    update!(unit_cost_cents: cost_groups.sum(:extended_value_sum_cents))
  end

  private

  def set_extended_cost
    self.extended_cost_cents = unit_cost_cents * units_requested
  end

  def saved_change_affecting_totals?
    saved_change_to_extended_cost_cents? || saved_change_to_units_requested? || saved_change_to_status?
  end

  # Totals are frozen once the SPO leaves an editable state.
  def recalculate_purchase_order_totals
    return unless style_purchase_order.editable?

    items = style_purchase_order.colorway_items.active
    style_purchase_order.update!(
      total_units: items.sum(:units_requested),
      total_cost_cents: items.sum(:extended_cost_cents)
    )
  end
end
