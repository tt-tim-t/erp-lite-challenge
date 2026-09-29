require "rails_helper"

RSpec.describe Reports::LandedCostReport do
  let(:item) { create(:colorway_item, units_requested: 10) }

  before do
    fabric_group = create(:cost_group, colorway_item: item, group_type: "fabric")
    create(:cost, cost_group: fabric_group, base_value_cents: 1_000, actualized_value_cents: 1_000)
    labor_group = create(:cost_group, colorway_item: item, group_type: "labor")
    create(:cost, cost_group: labor_group, base_value_cents: 1_500, actualized_value_cents: 1_500)
  end

  it "returns one row per active colorway item" do
    expect(described_class.call.size).to eq(1)
  end

  it "reports the landed cost per unit and in total" do
    row = described_class.call.first

    expect(row).to include(landed_cost_per_unit_cents: 2_500, landed_cost_total_cents: 25_000)
  end

  it "filters by season" do
    expect(described_class.call(season: create(:season))).to be_empty
  end
end
