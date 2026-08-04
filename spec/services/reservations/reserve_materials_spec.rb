require "rails_helper"

RSpec.describe Reservations::ReserveMaterials do
  let(:spo) { create(:style_purchase_order) }

  it "reserves the required quantity for each active material" do
    item = create(:colorway_item, style_purchase_order: spo, units_requested: 200)
    material = create(:material, colorway_item: item, estimated_yield: 2.5)

    described_class.call(spo)

    expect(material.reservations.sole.quantity).to eq(500)
  end

  it "skips canceled colorway items" do
    item = create(:colorway_item, style_purchase_order: spo, status: "canceled")
    create(:material, colorway_item: item)

    expect { described_class.call(spo) }.not_to change(Reservation, :count)
  end

  it "skips inactive materials" do
    item = create(:colorway_item, style_purchase_order: spo)
    create(:material, colorway_item: item, active: false)

    expect { described_class.call(spo) }.not_to change(Reservation, :count)
  end
end
