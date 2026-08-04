class FabricPolicy < ApplicationPolicy
  def index? = true
  def availability? = true

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
