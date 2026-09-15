require "rails_helper"

RSpec.describe StylePurchaseOrders::RecalculateTotals do
  let(:spo) { create(:style_purchase_order) }

  it "rolls up units and cost from the colorway items" do
    create(:colorway_item, style_purchase_order: spo, units_requested: 100, unit_cost_cents: 2_500)
    create(:colorway_item, style_purchase_order: spo, units_requested: 50, unit_cost_cents: 3_000)

    described_class.call(spo.reload)

    expect(spo.reload).to have_attributes(total_units: 150, total_cost_cents: 400_000)
  end

  it "leaves totals alone once the SPO is in production" do
    create(:colorway_item, style_purchase_order: spo, units_requested: 100, unit_cost_cents: 2_500)
    spo.update_columns(state: "production", total_units: 1, total_cost_cents: 1)

    described_class.call(spo.reload)

    expect(spo.reload).to have_attributes(total_units: 1, total_cost_cents: 1)
  end
end
