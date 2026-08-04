FactoryBot.define do
  factory :season do
    sequence(:code) { |n| "S#{n}" }
    name { "Test Season" }
  end

  factory :vendor do
    sequence(:name) { |n| "Vendor #{n}" }
    country_code { "US" }
    lane { "domestic" }
    email { "orders@vendor.test" }

    trait :overseas do
      lane { "overseas" }
      country_code { "PT" }
      sequence(:netsuite_id) { |n| "V-#{9000 + n}" }
    end
  end

  factory :sales_channel do
    name { "Reformation (BRD)" }
  end

  factory :style do
    sequence(:style_number) { |n| "RF-#{9000 + n}" }
    name { "Test Dress" }
    category { "Dresses" }
    season
  end

  factory :colorway do
    sequence(:name) { |n| "Color #{n}" }
    sequence(:color_code) { |n| "C#{n}" }
  end

  factory :colorway_style do
    style
    colorway
    status { "active" }
  end

  factory :fabric do
    sequence(:name) { |n| "Fabric #{n}" }
    fabric_type { "fabric" }
    measurement_units { "yards" }
    price { 5.0 }
    vendor

    trait :trim do
      fabric_type { "trim" }
      measurement_units { "each" }
      price { 0.5 }
    end
  end
end
