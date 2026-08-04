require "rails_helper"

RSpec.describe ReleaseStaleReservationsWorker do
  def reservation_for(state)
    spo = create(:style_purchase_order, state:)
    create(:reservation, material: create(:material, colorway_item: create(:colorway_item, style_purchase_order: spo)))
  end

  it "disables reservations on completed and canceled SPOs" do
    completed = reservation_for("completed")
    canceled = reservation_for("canceled")

    described_class.perform_now

    expect([completed.reload.state, canceled.reload.state]).to all(eq("disabled"))
  end

  it "leaves reservations on SPOs in production alone" do
    reservation = reservation_for("production")

    described_class.perform_now

    expect(reservation.reload.state).to eq("enabled")
  end
end
