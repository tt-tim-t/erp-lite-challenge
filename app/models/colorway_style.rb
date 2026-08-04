# A style in a specific colorway, e.g. RF-1042 Marlowe Midi Dress in Ivory.
class ColorwayStyle < ApplicationRecord
  STATUSES = %w[development active dropped].freeze

  belongs_to :style
  belongs_to :colorway
  has_many :colorway_items, dependent: :restrict_with_error

  validates :status, inclusion: { in: STATUSES }
  validates :colorway_id, uniqueness: { scope: :style_id }

  def display_name
    "#{style.style_number} #{style.name} - #{colorway.name}"
  end
end
