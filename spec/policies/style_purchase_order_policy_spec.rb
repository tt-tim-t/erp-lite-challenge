require "rails_helper"

RSpec.describe StylePurchaseOrderPolicy do
  let(:spo) { build(:style_purchase_order, state: "review") }

  def permitted?(role, action)
    described_class.new(build(:user, role:), spo).public_send(action)
  end

  it "lets production and admins send an SPO to production" do
    expect(%w[production admin].map { |role| permitted?(role, :send_to_production?) }).to all(be(true))
  end

  it "refuses to let anyone else send an SPO to production" do
    expect(%w[viewer merchandiser finance].map { |role| permitted?(role, :send_to_production?) }).to all(be(false))
  end

  it "lets merchandisers submit for review" do
    expect(permitted?("merchandiser", :submit_for_review?)).to be(true)
  end

  it "refuses updates once the SPO is in production" do
    spo.state = "production"

    expect(permitted?("admin", :update?)).to be(false)
  end
end
