class CostGroup < ApplicationRecord
  GROUP_TYPES = %w[fabric trim labor freight duty].freeze

  belongs_to :colorway_item
  has_many :costs, dependent: :destroy

  validates :group_type, inclusion: { in: GROUP_TYPES }
  validates :group_type, uniqueness: { scope: :colorway_item_id }

  def recalculate!
    update!(extended_value_sum_cents: costs.sum(:extended_value_cents))
    colorway_item.refresh_unit_cost!
  end
end
