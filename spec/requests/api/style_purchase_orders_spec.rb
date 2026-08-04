require "rails_helper"

RSpec.describe "Api::StylePurchaseOrders" do
  let(:merchandiser) { create(:user, :merchandiser) }

  describe "GET /api/style_purchase_orders" do
    it "requires a known user" do
      get "/api/style_purchase_orders"

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns the standard success shape" do
      create_list(:style_purchase_order, 2)

      get "/api/style_purchase_orders", headers: auth_headers(merchandiser)

      expect(json_body).to include("success" => true, "totalCount" => 2)
      expect(json_body["data"].first.keys).to include("po_number", "vendor", "total_cost_cents")
    end
  end

  describe "GET /api/style_purchase_orders/:id" do
    it "lists only active colorway items" do
      spo = create(:style_purchase_order)
      active = create(:colorway_item, style_purchase_order: spo)
      create(:colorway_item, style_purchase_order: spo, status: "canceled")

      get "/api/style_purchase_orders/#{spo.id}", headers: auth_headers(merchandiser)

      expect(json_body.dig("data", "colorway_items").pluck("id")).to eq([active.id])
    end
  end

  describe "PATCH /api/style_purchase_orders/:id/send_to_production" do
    it "is forbidden for merchandisers" do
      spo = create(:style_purchase_order, state: "review")

      patch "/api/style_purchase_orders/#{spo.id}/send_to_production", headers: auth_headers(merchandiser)

      expect(response).to have_http_status(:forbidden)
    end
  end
end
