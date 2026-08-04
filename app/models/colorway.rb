class Colorway < ApplicationRecord
  has_many :colorway_styles, dependent: :restrict_with_error
  has_many :styles, through: :colorway_styles

  validates :name, :color_code, presence: true
end
