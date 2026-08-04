require "rails_helper"

RSpec.describe Cost do
  it "grosses the base value up by the loss rate" do
    cost = create(:cost, base_value_cents: 1_000, loss_rate: 0.05)

    expect(cost.extended_value_cents).to eq(1_050)
  end

  it "rolls up into its cost group and the colorway item's unit cost" do
    cost = create(:cost, base_value_cents: 1_200)

    expect(cost.cost_group.reload.extended_value_sum_cents).to eq(1_200)
    expect(cost.cost_group.colorway_item.reload.unit_cost_cents).to eq(1_200)
  end

  it "cannot change once the cost sheet is locked" do
    cost = create(:cost, base_value_cents: 1_000)
    item = cost.cost_group.colorway_item.reload
    item.cost_sheet_approved!
    item.cost_sheet_locked!

    expect(cost.reload.update(base_value_cents: 2_000)).to be(false)
    expect(cost.errors[:base_value_cents]).to be_present
  end
end
