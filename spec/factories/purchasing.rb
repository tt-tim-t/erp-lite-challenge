FactoryBot.define do
  factory :style_purchase_order do
    sequence(:po_number) { |n| "SPO-#{9000 + n}" }
    style
    vendor
    sales_channel
    owner factory: :user
  end

  factory :colorway_item do
    style_purchase_order
    colorway_style { association :colorway_style, style: style_purchase_order.style }
    units_requested { 100 }
    unit_cost_cents { 2_000 }
    original_delivery_date { 2.months.from_now.to_date }
  end

  factory :cost_group do
    colorway_item
    group_type { "labor" }
  end

  factory :cost do
    cost_group
    name { "Cut, make, trim" }
    base_value_cents { 1_000 }
    loss_rate { 0 }
  end

  factory :material do
    colorway_item
    fabric
    use { "body" }
    estimated_yield { 2.0 }
  end

  factory :reservation do
    material
    quantity { 10 }
  end
end
