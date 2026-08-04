module Api
  # A cost sheet is the set of cost groups and costs on one colorway item.
  class CostSheetsController < BaseController
    before_action :set_colorway_item

    # Locking is also triggered by finance's month-end close-out script,
    # which runs as a service user.
    skip_after_action :verify_authorized, only: :lock

    def show
      authorize @colorway_item, policy_class: CostSheetPolicy
      render_success(CostSheetSerializer.new(@colorway_item).as_json)
    end

    def approve
      authorize @colorway_item, :approve?, policy_class: CostSheetPolicy

      if @colorway_item.cost_sheet_approved
        render_success(CostSheetSerializer.new(@colorway_item).as_json)
      else
        render_errors("Cost sheet cannot be approved from #{@colorway_item.cost_sheet_state}")
      end
    end

    def lock
      result = CostSheets::Lock.call(@colorway_item, user: current_user)
      render_result(result, CostSheetSerializer.new(@colorway_item.reload).as_json)
    end

    private

    def set_colorway_item
      @colorway_item = ColorwayItem.find(params[:colorway_item_id])
    end
  end
end
