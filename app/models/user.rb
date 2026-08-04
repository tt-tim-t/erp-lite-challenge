class User < ApplicationRecord
  ROLES = %w[viewer merchandiser production finance admin].freeze

  has_many :owned_style_purchase_orders,
           class_name: "StylePurchaseOrder",
           foreign_key: :owner_id,
           inverse_of: :owner,
           dependent: :restrict_with_error

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, inclusion: { in: ROLES }

  ROLES.each do |role_name|
    define_method(:"#{role_name}?") { role == role_name }
  end

  def role_in?(*roles)
    roles.map(&:to_s).include?(role)
  end
end
