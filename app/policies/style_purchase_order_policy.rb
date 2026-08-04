class StylePurchaseOrderPolicy < ApplicationPolicy
  def index? = true
  def show? = true

  def update?
    user.role_in?(:merchandiser, :production, :admin) && record.editable?
  end

  def submit_for_review?
    user.role_in?(:merchandiser, :admin)
  end

  def send_to_production?
    user.role_in?(:production, :admin)
  end

  def cancel?
    user.role_in?(:production, :admin)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
