class Style < ApplicationRecord
  belongs_to :season
  has_many :colorway_styles, dependent: :destroy
  has_many :colorways, through: :colorway_styles
  has_many :style_purchase_orders, dependent: :restrict_with_error

  validates :style_number, presence: true, uniqueness: true
  validates :name, presence: true
end
