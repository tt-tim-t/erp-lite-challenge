require "rails_helper"

RSpec.describe StylePurchaseOrder do
  describe "#editable?" do
    it "is editable while created, in review, or rejected" do
      expect(%w[created review rejected].map { |state| build(:style_purchase_order, state:).editable? }).to all(be(true))
    end

    it "is not editable once in production" do
      expect(build(:style_purchase_order, state: "production")).not_to be_editable
    end
  end

  describe "total freeze" do
    it "allows total changes while editable" do
      spo = create(:style_purchase_order, state: "review")
      expect(spo.update(total_cost_cents: 123)).to be(true)
    end

    it "refuses to change totals after the SPO is sent to production" do
      spo = create(:style_purchase_order, state: "production")

      expect(spo.update(total_cost_cents: 123)).to be(false)
      expect(spo.errors[:total_cost_cents]).to be_present
    end
  end

  describe ".search" do
    let!(:spo) { create(:style_purchase_order, po_number: "SPO-4242", style: create(:style, style_number: "RF-7777")) }

    before { create(:style_purchase_order, po_number: "SPO-1111") }

    it "matches on PO number" do
      expect(described_class.search("4242")).to contain_exactly(spo)
    end

    it "matches on style number" do
      expect(described_class.search("RF-7777")).to contain_exactly(spo)
    end

    it "returns everything for a blank term" do
      expect(described_class.search("").count).to eq(2)
    end
  end

  describe ".with_upcoming_deliveries" do
    it "returns SPOs with at least one active colorway delivering in the future" do
      upcoming = create(:colorway_item, original_delivery_date: 3.weeks.from_now.to_date).style_purchase_order
      create(:colorway_item, original_delivery_date: 3.weeks.ago.to_date)

      expect(described_class.with_upcoming_deliveries).to contain_exactly(upcoming)
    end
  end
end
