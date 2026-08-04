# Fabric held for a material once its SPO is sent to production.
class Reservation < ApplicationRecord
  include ReservationStateMachine

  belongs_to :material
  has_one :fabric, through: :material

  scope :enabled, -> { where(state: "enabled") }

  validates :quantity, numericality: { greater_than: 0 }
end
