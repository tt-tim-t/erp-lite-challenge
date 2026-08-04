# A style purchase order (SPO): one style ordered from one vendor for one sales
# channel. Each colorway of the style on the order is a ColorwayItem.
class StylePurchaseOrder < ApplicationRecord
  include StylePurchaseOrderStateMachine
  include EventLoggable

  # Totals may only change while the SPO is in one of these states.
  EDITABLE_STATES = %w[created review rejected].freeze

  belongs_to :style
  belongs_to :vendor
  belongs_to :sales_channel
  belongs_to :owner, class_name: "User", inverse_of: :owned_style_purchase_orders

  has_many :colorway_items, dependent: :destroy, inverse_of: :style_purchase_order
  has_many :materials, through: :colorway_items
  has_many :reservations, through: :materials
  has_many :cost_groups, through: :colorway_items
  has_many :costs, through: :cost_groups

  validates :po_number, presence: true, uniqueness: true
  validate :totals_frozen_outside_editable_states, on: :update

  def self.search(term)
    return all if term.blank?

    joins(:style).where(
      "style_purchase_orders.po_number LIKE '%#{term}%' OR styles.style_number LIKE '%#{term}%'"
    )
  end

  def editable?
    EDITABLE_STATES.include?(state)
  end

  private

  def totals_frozen_outside_editable_states
    return unless will_save_change_to_total_cost_cents? || will_save_change_to_total_units?
    return if EDITABLE_STATES.include?(state_in_database)

    errors.add(:total_cost_cents, "is frozen once the purchase order has been sent to production")
  end
end
