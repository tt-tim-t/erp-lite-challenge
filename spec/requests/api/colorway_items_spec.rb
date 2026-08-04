require "rails_helper"

RSpec.describe "Api::ColorwayItems" do
  let(:merchandiser) { create(:user, :merchandiser) }
  let(:item) { create(:colorway_item, units_requested: 100) }

  describe "PATCH /api/colorway_items/:id" do
    it "updates units while the SPO is editable" do
      patch "/api/colorway_items/#{item.id}", params: { colorway_item: { units_requested: 120 } }, headers: auth_headers(merchandiser)

      expect(response).to have_http_status(:ok)
      expect(item.reload.units_requested).to eq(120)
    end

    it "is forbidden once the SPO is in production" do
      item.style_purchase_order.update_columns(state: "production")

      patch "/api/colorway_items/#{item.id}", params: { colorway_item: { units_requested: 120 } }, headers: auth_headers(merchandiser)

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /api/colorway_items/:id/cancel" do
    it "cancels the colorway item" do
      patch "/api/colorway_items/#{item.id}/cancel", headers: auth_headers(merchandiser)

      expect(json_body.dig("data", "status")).to eq("canceled")
    end

    it "is forbidden for viewers" do
      patch "/api/colorway_items/#{item.id}/cancel", headers: auth_headers(create(:user, :viewer))

      expect(response).to have_http_status(:forbidden)
    end
  end
end
