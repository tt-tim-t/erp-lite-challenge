require "rails_helper"

RSpec.describe Fabric do
  describe "#cost_cents_for" do
    it "converts the dollar price into cents for a quantity" do
      fabric = build(:fabric, price: 5.0)

      expect(fabric.cost_cents_for(2)).to eq(1_000)
    end
  end

  describe "#reserved_quantity" do
    it "sums only enabled reservations" do
      fabric = create(:fabric)
      material = create(:material, fabric:)
      create(:reservation, material:, quantity: 12.5)
      create(:reservation, material:, quantity: 4, state: "closed")

      expect(fabric.reserved_quantity).to eq(12.5)
    end
  end
end
