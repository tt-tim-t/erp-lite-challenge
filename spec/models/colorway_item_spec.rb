require "rails_helper"

RSpec.describe ColorwayItem do
  describe "extended cost" do
    it "multiplies unit cost by units requested" do
      item = create(:colorway_item, unit_cost_cents: 2_550, units_requested: 40)

      expect(item.extended_cost_cents).to eq(102_000)
    end
  end

  describe "#actual_cost_per_unit_cents" do
    let(:item) { create(:colorway_item) }

    before do
      create(:cost, cost_group: create(:cost_group, colorway_item: item, group_type: "labor"), base_value_cents: 1_500)
      create(:cost, cost_group: create(:cost_group, colorway_item: item, group_type: "freight"), base_value_cents: 300)
    end

    it "is nil until the cost sheet is locked" do
      expect(item.reload.actual_cost_per_unit_cents).to be_nil
    end

    it "sums the cost groups once the cost sheet is locked" do
      item.reload.cost_sheet_approved!
      item.cost_sheet_locked!

      expect(item.actual_cost_per_unit_cents).to eq(1_800)
    end
  end

  describe "SPO totals" do
    it "rolls the new units into the SPO when units change" do
      item = create(:colorway_item, units_requested: 100, unit_cost_cents: 1_000)

      item.update!(units_requested: 150)

      expect(item.style_purchase_order.reload).to have_attributes(total_units: 150, total_cost_cents: 150_000)
    end
  end
end
