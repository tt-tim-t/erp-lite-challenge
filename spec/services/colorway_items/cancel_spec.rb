require "rails_helper"

RSpec.describe ColorwayItems::Cancel do
  let(:item) { create(:colorway_item) }

  it "marks the colorway item canceled" do
    described_class.call(item)

    expect(item.reload.status).to eq("canceled")
  end

  it "disables the item's fabric reservations" do
    reservation = create(:reservation, material: create(:material, colorway_item: item))

    described_class.call(item)

    expect(reservation.reload.state).to eq("disabled")
  end

  it "refuses to cancel twice" do
    item.update!(status: "canceled")

    expect(described_class.call(item)).not_to be_success
  end
end
