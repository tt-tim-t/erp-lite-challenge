class Season < ApplicationRecord
  has_many :styles, dependent: :restrict_with_error

  validates :name, :code, presence: true
  validates :code, uniqueness: true
end
