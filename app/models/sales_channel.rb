# Where the goods on an SPO will be sold. Consumer channels are named after
# the brand and the distribution center ("Reformation (BRD)"); partner-named
# channels ("Nordstrom (BRD)") are wholesale.
class SalesChannel < ApplicationRecord
  has_many :style_purchase_orders, dependent: :restrict_with_error

  scope :consumer, -> { where(wholesale: false) }
  scope :wholesale, -> { where(wholesale: true) }

  validates :name, presence: true
end
