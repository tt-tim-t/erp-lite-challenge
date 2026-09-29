module Api
  class ReportsController < BaseController
    def landed_cost
      authorize :report, :landed_cost?

      season = Season.find_by!(code: params[:season]) if params[:season].present?
      rows = Reports::LandedCostReport.call(season:)
      render_success(rows, total_count: rows.size)
    end
  end
end
