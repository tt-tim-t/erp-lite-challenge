# A single line on a cost sheet, per garment unit. extended_value_cents is the
# base value grossed up by the loss rate.
class Cost < ApplicationRecord
  belongs_to :cost_group
  belongs_to :vendor, optional: true
  belongs_to :fabric, optional: true
  has_one :colorway_item, through: :cost_group

  validates :name, presence: true
  validate :cost_sheet_unlocked, if: :estimate_changing?

  before_save :set_extended_value
  after_save :recalculate_cost_group, if: :saved_change_to_extended_value_cents?
  after_destroy :recalculate_cost_group

  private

  def set_extended_value
    self.extended_value_cents = (base_value_cents * (1 + loss_rate)).round
  end

  def estimate_changing?
    persisted? && (will_save_change_to_base_value_cents? || will_save_change_to_loss_rate?)
  end

  def cost_sheet_unlocked
    return unless cost_group.colorway_item.cost_sheet_locked?

    errors.add(:base_value_cents, "cannot change after the cost sheet is locked")
  end

  def recalculate_cost_group
    cost_group.recalculate!
  end
end
