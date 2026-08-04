# Raw materials library: fabrics (priced per yard) and trims (priced each).
class Fabric < ApplicationRecord
  FABRIC_TYPES = %w[fabric trim].freeze

  belongs_to :vendor, optional: true
  has_many :materials, dependent: :restrict_with_error
  has_many :reservations, through: :materials

  validates :name, presence: true
  validates :fabric_type, inclusion: { in: FABRIC_TYPES }

  # `price` is the legacy dollars column. Returns the cost in cents for a quantity
  # measured in this fabric's measurement_units.
  def cost_cents_for(quantity)
    (price.to_f * quantity.to_f * 100).to_i
  end

  def reserved_quantity
    reservations.enabled.sum(:quantity)
  end
end
