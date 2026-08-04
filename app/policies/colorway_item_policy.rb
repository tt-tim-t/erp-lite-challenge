class ColorwayItemPolicy < ApplicationPolicy
  def update?
    user.role_in?(:merchandiser, :production, :admin) && record.style_purchase_order.editable?
  end

  def cancel?
    user.role_in?(:merchandiser, :production, :admin)
  end
end
