module CostSheets
  # Locks an approved cost sheet. From this point its estimates are the item's
  # actual costs and the unit cost is frozen.
  class Lock < ApplicationService
    def initialize(colorway_item, user:)
      @colorway_item = colorway_item
      @user = user
    end

    def call
      return ServiceResult.failure("Only approved cost sheets can be locked") unless colorway_item.can_cost_sheet_locked?

      colorway_item.cost_sheet_locked!
      ServiceResult.success
    end

    private

    attr_reader :colorway_item, :user
  end
end
