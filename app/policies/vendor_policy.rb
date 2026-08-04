class VendorPolicy < ApplicationPolicy
  def index? = true

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
