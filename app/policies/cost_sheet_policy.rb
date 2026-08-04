# Authorizes cost sheet actions. The record is the ColorwayItem that owns the sheet.
class CostSheetPolicy < ApplicationPolicy
  def show? = true

  def approve?
    user.role_in?(:merchandiser, :admin)
  end

  # Locking turns estimates into actuals, so only finance can do it.
  def lock?
    user.role_in?(:finance, :admin)
  end
end
