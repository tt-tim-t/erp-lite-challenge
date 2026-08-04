require "rails_helper"

RSpec.describe CostSheets::BuildFromMaterials do
  let(:item) { create(:colorway_item) }

  it "builds fabric and trim cost groups from the bill of materials" do
    create(:material, colorway_item: item, fabric: create(:fabric, price: 5.0), estimated_yield: 2)
    create(:material, colorway_item: item, fabric: create(:fabric, :trim, price: 0.5), estimated_yield: 4, use: "trim")

    described_class.call(item)

    sums = item.cost_groups.pluck(:group_type, :extended_value_sum_cents).to_h
    expect(sums).to eq("fabric" => 1_030, "trim" => 206)
  end

  it "replaces previously built material costs" do
    create(:material, colorway_item: item, estimated_yield: 2)
    described_class.call(item)

    expect { described_class.call(item) }.not_to change(Cost, :count)
  end
end
