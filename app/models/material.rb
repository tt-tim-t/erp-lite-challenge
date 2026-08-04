# A fabric or trim used by a colorway item (one line of its bill of materials).
class Material < ApplicationRecord
  USES = %w[body lining trim].freeze

  belongs_to :colorway_item
  belongs_to :fabric
  has_many :reservations, dependent: :destroy

  scope :active, -> { where(active: true) }

  validates :use, inclusion: { in: USES }
  validates :estimated_yield, numericality: { greater_than_or_equal_to: 0 }

  # Total fabric needed for the units requested on the colorway item.
  def required_quantity
    colorway_item.units_requested * estimated_yield
  end

  def reserved_quantity
    reservations.enabled.sum(:quantity)
  end
end
