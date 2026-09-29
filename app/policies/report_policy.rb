# Headless policy for reports: `authorize :report, :landed_cost?`.
class ReportPolicy < ApplicationPolicy
  def landed_cost?
    user.role_in?(:finance, :admin)
  end
end
