module Api
  class VendorsController < BaseController
    def index
      authorize Vendor

      vendors = policy_scope(Vendor).active.order(:name)
      render_success(vendors.as_json(only: %i[id name country_code lane]), total_count: vendors.size)
    end
  end
end
