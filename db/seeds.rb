# Deterministic seed data for ERP Lite. Rebuild from scratch with: bin/setup --reset
#
# Seeding goes through the same models, services, and state machine events the
# API uses, so callbacks, totals, reservations, and event logs are all real.

rng = Random.new(20_260_803)

def pick(list, rng) = list.sample(random: rng)

puts "Seeding users, seasons, vendors, and channels..."

users = {
  viewer: User.create!(email: "viewer@erp-lite.test", name: "Sam Ortiz", role: "viewer"),
  merchandiser: User.create!(email: "merch@erp-lite.test", name: "Morgan Lee", role: "merchandiser"),
  production: User.create!(email: "production@erp-lite.test", name: "Priya Shah", role: "production"),
  finance: User.create!(email: "finance@erp-lite.test", name: "Dana Kim", role: "finance"),
  admin: User.create!(email: "admin@erp-lite.test", name: "Alex Rivera", role: "admin")
}

seasons = {
  "SP26" => Season.create!(code: "SP26", name: "Spring 2026", starts_on: "2026-02-01", ends_on: "2026-04-30"),
  "SU26" => Season.create!(code: "SU26", name: "Summer 2026", starts_on: "2026-05-01", ends_on: "2026-07-31"),
  "FA26" => Season.create!(code: "FA26", name: "Fall 2026", starts_on: "2026-08-01", ends_on: "2026-10-31"),
  "HO26" => Season.create!(code: "HO26", name: "Holiday 2026", starts_on: "2026-11-01", ends_on: "2027-01-31")
}

garment_vendors = [
  Vendor.create!(name: "Harbor Line Apparel", country_code: "US", lane: "domestic", email: "orders@harborline.test", netsuite_id: "V-1001"),
  Vendor.create!(name: "Westbrook Sewing Co.", country_code: "US", lane: "domestic", email: "po@westbrooksewing.test", netsuite_id: "V-1002"),
  Vendor.create!(name: "Atelier Nova", country_code: "PT", lane: "overseas", email: "orders@ateliernova.test", netsuite_id: "V-2001"),
  Vendor.create!(name: "Sunrise Garment Works", country_code: "VN", lane: "overseas", email: "sales@sunrisegw.test", netsuite_id: "V-2002"),
  Vendor.create!(name: "Lumen Knits", country_code: "CN", lane: "overseas", email: "po@lumenknits.test", netsuite_id: "V-2003")
]
mill = Vendor.create!(name: "Marisol Textiles", country_code: "IN", lane: "overseas", email: "mill@marisoltextiles.test", netsuite_id: "V-3001")
trim_supplier = Vendor.create!(name: "Cordero Trims", country_code: "US", lane: "domestic", email: "orders@corderotrims.test", netsuite_id: "V-3002")
Vendor.create!(name: "Old Mill Garments", country_code: "US", lane: "domestic", email: "info@oldmill.test", active: false)

channels = {
  brd: SalesChannel.create!(name: "Reformation (BRD)"),
  vrn: SalesChannel.create!(name: "Reformation (VRN)"),
  cvh: SalesChannel.create!(name: "Reformation UK (CVH)"),
  nordstrom: SalesChannel.create!(name: "Nordstrom (BRD)", wholesale: true),
  revolve: SalesChannel.create!(name: "Revolve (VRN)", wholesale: true)
}

puts "Seeding fabrics and trims..."

body_fabrics = [
  ["Crepe de Chine", 6.85], ["Linen Slub", 4.35], ["Viscose Twill", 3.15], ["Organic Cotton Poplin", 4.10],
  ["Recycled Satin", 8.75], ["Tencel Jersey", 5.60], ["Silk Charmeuse", 14.20], ["Rib Knit", 4.95]
].map { |name, price| Fabric.create!(name:, price:, fabric_type: "fabric", measurement_units: "yards", vendor: mill) }
lining = Fabric.create!(name: "Lining Voile", price: 2.30, fabric_type: "fabric", measurement_units: "yards", vendor: mill)
trims = {
  button: Fabric.create!(name: "Corozo Button 18L", price: 0.12, fabric_type: "trim", measurement_units: "each", vendor: trim_supplier),
  zipper: Fabric.create!(name: "Invisible Zipper 22in", price: 0.85, fabric_type: "trim", measurement_units: "each", vendor: trim_supplier),
  label: Fabric.create!(name: "Woven Main Label", price: 0.07, fabric_type: "trim", measurement_units: "each", vendor: trim_supplier),
  hang_tag: Fabric.create!(name: "Hang Tag Set", price: 0.19, fabric_type: "trim", measurement_units: "each", vendor: trim_supplier),
  elastic: Fabric.create!(name: "Elastic 1in", price: 0.45, fabric_type: "trim", measurement_units: "yards", vendor: trim_supplier)
}

puts "Seeding styles and colorways..."

colorways = [
  %w[Ivory IVR], %w[Black BLK], %w[Sage SAG], %w[Cobalt CBT], %w[Terracotta TER],
  %w[Navy NVY], %w[Rose RSE], %w[Oat OAT], %w[Poppy POP], %w[Forest FOR]
].to_h { |name, code| [name, Colorway.create!(name:, color_code: code)] }

style_names = [
  ["Juniper Top", "Tops"], ["Calla Wide Leg Pant", "Bottoms"], ["Wren Linen Dress", "Dresses"],
  ["Sloane Cardigan", "Knits"], ["Bexley Blouse", "Tops"], ["Ottilie Slip Skirt", "Bottoms"],
  ["Nadia Maxi Dress", "Dresses"], ["Pia Tank", "Tops"], ["Harlow Trouser", "Bottoms"],
  ["Ines Wrap Dress", "Dresses"], ["Cove Rib Tee", "Knits"], ["Marlowe Midi Dress", "Dresses"],
  ["Tamsin Shirt", "Tops"], ["Vera Mini Skirt", "Bottoms"], ["Delphine Gown", "Dresses"],
  ["Lio Sweater", "Knits"], ["Ruth Camisole", "Tops"], ["Elodie Jumpsuit", "Dresses"],
  ["Kit Short", "Bottoms"], ["Astrid Dress", "Dresses"], ["Mae Polo", "Knits"],
  ["Ondine Halter Top", "Tops"], ["Greer Barrel Pant", "Bottoms"], ["Simone Shirt Dress", "Dresses"]
]
season_codes = %w[SP26 SU26 FA26 HO26]

styles = style_names.each_with_index.map do |(name, category), index|
  style_number = "RF-#{1031 + index}"
  season = style_number == "RF-1042" ? seasons["FA26"] : seasons[season_codes[index % 4]]
  Style.create!(style_number:, name:, category:, season:)
end

styles.each do |style|
  names = style.style_number == "RF-1042" ? %w[Ivory Black Sage] : colorways.keys.sample(3, random: rng)
  names.each { |name| ColorwayStyle.create!(style:, colorway: colorways[name], status: "active") }
end

puts "Seeding style purchase orders and cost sheets (this takes a few seconds)..."

def add_materials(colorway_item, body_fabrics, lining, trims, rng)
  body = body_fabrics.sample(random: rng)
  Material.create!(colorway_item:, fabric: body, use: "body", estimated_yield: [1.5, 2.0, 2.25, 2.5, 3.0, 3.5].sample(random: rng))
  Material.create!(colorway_item:, fabric: lining, use: "lining", estimated_yield: [1.0, 1.25, 1.5].sample(random: rng)) if rng.rand < 0.4
  Material.create!(colorway_item:, fabric: trims[:label], use: "trim", estimated_yield: 1)
  Material.create!(colorway_item:, fabric: trims[:hang_tag], use: "trim", estimated_yield: 1)
  if body.name.match?(/Jersey|Rib/)
    Material.create!(colorway_item:, fabric: trims[:elastic], use: "trim", estimated_yield: 0.75)
  elsif rng.rand < 0.5
    Material.create!(colorway_item:, fabric: trims[:button], use: "trim", estimated_yield: [4, 6, 8].sample(random: rng))
  else
    Material.create!(colorway_item:, fabric: trims[:zipper], use: "trim", estimated_yield: 1)
  end
end

def add_cost_sheet(colorway_item, vendor, rng)
  CostSheets::BuildFromMaterials.call(colorway_item)

  labor = colorway_item.cost_groups.create!(group_type: "labor")
  labor.costs.create!(name: "Cut, make, trim", vendor:, base_value_cents: rng.rand(900..2_600))

  freight = colorway_item.cost_groups.create!(group_type: "freight")
  freight_cents = vendor.overseas? ? rng.rand(180..450) : rng.rand(60..120)
  freight.costs.create!(name: vendor.overseas? ? "Ocean freight" : "Ground freight", base_value_cents: freight_cents)

  return unless vendor.overseas?

  duty = colorway_item.cost_groups.create!(group_type: "duty")
  duty.costs.create!(name: "Import duty", base_value_cents: rng.rand(300..900))
end

def lock_cost_sheet(colorway_item)
  colorway_item.cost_sheet_approved!
  colorway_item.cost_sheet_locked!
end

# [po_number suffix => target state]. Everything not listed is "created".
plan = {
  1001 => "created", 1002 => "created", 1003 => "review", 1004 => "review", 1005 => "production",
  1006 => "production", 1007 => "completed", 1008 => "review", 1009 => "rejected", 1010 => "production",
  1011 => "canceled", 1012 => "production", 1013 => "review", 1014 => "completed", 1015 => "production",
  1016 => "created", 1017 => "created", 1018 => "production", 1019 => "review", 1020 => "completed",
  1021 => "production", 1022 => "rejected", 1023 => "production", 1024 => "review", 1025 => "completed",
  1026 => "canceled", 1027 => "production", 1028 => "created", 1029 => "review", 1030 => "production",
  1031 => "completed", 1032 => "production", 1033 => "review", 1034 => "rejected", 1035 => "production",
  1036 => "created", 1037 => "canceled", 1038 => "production", 1039 => "completed", 1040 => "review"
}

# SPOs that have one colorway canceled while still editable.
cancel_one_line = [1003, 1017, 1021]

consumer_channels = channels.values_at(:brd, :vrn, :cvh)
style_by_number = styles.index_by(&:style_number)

plan.each do |suffix, target_state|
  po_number = "SPO-#{suffix}"
  style = suffix == 1012 ? style_by_number["RF-1042"] : styles[(suffix - 1001) % styles.size]
  vendor = suffix == 1012 ? garment_vendors[2] : garment_vendors[(suffix * 7) % garment_vendors.size]
  channel = (suffix % 9).zero? ? pick([channels[:nordstrom], channels[:revolve]], rng) : pick(consumer_channels, rng)

  spo = StylePurchaseOrder.create!(
    po_number:, style:, vendor:, sales_channel: channel, owner: users[:merchandiser]
  )

  colorway_styles = style.colorway_styles.order(:id).to_a
  colorway_styles = colorway_styles.first(2) if suffix == 1012
  colorway_styles = colorway_styles.first(rng.rand(2..3)) unless [1003, 1012].include?(suffix)

  colorway_styles.each_with_index do |colorway_style, line|
    original = Date.new(2026, 9, 1) + rng.rand(0..210)
    item = ColorwayItem.create!(
      style_purchase_order: spo,
      colorway_style:,
      units_requested: rng.rand(6..48) * 25,
      original_delivery_date: original,
      revised_delivery_date: (original + rng.rand(7..35) if rng.rand < 0.3)
    )
    add_materials(item, body_fabrics, lining, trims, rng)
    add_cost_sheet(item, vendor, rng)

    case target_state
    when "production", "completed"
      lock_cost_sheet(item)
    when "review", "canceled"
      lock_cost_sheet(item) if line.even?
      item.cost_sheet_approved! if line.odd?
    end
  end

  spo.submit_for_review! unless target_state == "created"
  ColorwayItems::Cancel.call(spo.colorway_items.order(:id).last) if cancel_one_line.include?(suffix)

  case target_state
  when "rejected"
    spo.reject!
  when "production", "completed"
    result = StylePurchaseOrders::SendToProduction.call(spo, user: users[:production])
    raise "Could not send #{po_number} to production: #{result.errors.join(', ')}" unless result.success?

    spo.complete! if target_state == "completed"
  when "canceled"
    StylePurchaseOrders::Cancel.call(spo, reason: pick(["Fabric delay", "Buy reduced", "Style dropped"], rng))
  end
end

puts "Seeding legacy reconciliation values..."

# A handful of costs carry a value in the legacy actualized column, written by
# an old invoice reconciliation job. Most rows were never touched.
Cost.joins(cost_group: { colorway_item: :style_purchase_order })
    .where(style_purchase_orders: { state: "completed" })
    .order(:id)
    .each { |cost| cost.update_columns(actualized_value_cents: cost.extended_value_cents + rng.rand(-80..120)) if rng.rand < 0.15 }

marlowe_ivory = ColorwayItem.joins(colorway_style: %i[style colorway])
                            .find_by!(styles: { style_number: "RF-1042" }, colorways: { name: "Ivory" })
marlowe_ivory.cost_groups.find_by!(group_type: "fabric").costs.each do |cost|
  cost.update_columns(actualized_value_cents: cost.extended_value_cents - 35)
end

puts "Done: #{StylePurchaseOrder.count} SPOs, #{ColorwayItem.count} colorway items, " \
     "#{Cost.count} costs, #{Reservation.count} reservations, #{EventLog.count} event logs."
