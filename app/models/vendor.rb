class Vendor < ApplicationRecord
  LANES = %w[domestic overseas].freeze

  has_many :style_purchase_orders, dependent: :restrict_with_error
  has_many :fabrics, dependent: :nullify

  scope :active, -> { where(active: true) }

  validates :name, :country_code, presence: true
  validates :lane, inclusion: { in: LANES }

  def domestic?
    lane == "domestic"
  end

  def overseas?
    lane == "overseas"
  end
end
