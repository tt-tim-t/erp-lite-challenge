# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_08_03_160400) do
  create_table "colorway_items", force: :cascade do |t|
    t.integer "style_purchase_order_id", null: false
    t.integer "colorway_style_id", null: false
    t.string "status", default: "active", null: false
    t.string "cost_sheet_state", default: "draft", null: false
    t.integer "units_requested", default: 0, null: false
    t.integer "units_received", default: 0, null: false
    t.integer "unit_cost_cents", default: 0, null: false
    t.integer "extended_cost_cents", default: 0, null: false
    t.date "original_delivery_date"
    t.date "revised_delivery_date"
    t.datetime "cost_sheet_locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["colorway_style_id"], name: "index_colorway_items_on_colorway_style_id"
    t.index ["style_purchase_order_id"], name: "index_colorway_items_on_style_purchase_order_id"
  end

  create_table "colorway_styles", force: :cascade do |t|
    t.integer "style_id", null: false
    t.integer "colorway_id", null: false
    t.string "status", default: "development", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["colorway_id"], name: "index_colorway_styles_on_colorway_id"
    t.index ["style_id", "colorway_id"], name: "index_colorway_styles_on_style_id_and_colorway_id", unique: true
    t.index ["style_id"], name: "index_colorway_styles_on_style_id"
  end

  create_table "colorways", force: :cascade do |t|
    t.string "name", null: false
    t.string "color_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cost_groups", force: :cascade do |t|
    t.integer "colorway_item_id", null: false
    t.string "group_type", null: false
    t.integer "extended_value_sum_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["colorway_item_id", "group_type"], name: "index_cost_groups_on_colorway_item_id_and_group_type", unique: true
    t.index ["colorway_item_id"], name: "index_cost_groups_on_colorway_item_id"
  end

  create_table "costs", force: :cascade do |t|
    t.integer "cost_group_id", null: false
    t.integer "vendor_id"
    t.integer "fabric_id"
    t.string "name", null: false
    t.integer "base_value_cents", default: 0, null: false
    t.decimal "loss_rate", precision: 5, scale: 4, default: "0.0", null: false
    t.integer "extended_value_cents", default: 0, null: false
    t.integer "actualized_value_cents"
    t.datetime "po_triggered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cost_group_id"], name: "index_costs_on_cost_group_id"
    t.index ["fabric_id"], name: "index_costs_on_fabric_id"
    t.index ["vendor_id"], name: "index_costs_on_vendor_id"
  end

  create_table "event_logs", force: :cascade do |t|
    t.string "event_source_type", null: false
    t.integer "event_source_id", null: false
    t.integer "user_id"
    t.string "event", null: false
    t.json "details"
    t.datetime "created_at", null: false
    t.index ["event_source_type", "event_source_id"], name: "index_event_logs_on_event_source"
    t.index ["user_id"], name: "index_event_logs_on_user_id"
  end

  create_table "fabrics", force: :cascade do |t|
    t.string "name", null: false
    t.string "fabric_type", default: "fabric", null: false
    t.string "measurement_units", default: "yards", null: false
    t.float "price"
    t.integer "vendor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vendor_id"], name: "index_fabrics_on_vendor_id"
  end

  create_table "materials", force: :cascade do |t|
    t.integer "colorway_item_id", null: false
    t.integer "fabric_id", null: false
    t.string "use", default: "body", null: false
    t.decimal "estimated_yield", precision: 8, scale: 3, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["colorway_item_id"], name: "index_materials_on_colorway_item_id"
    t.index ["fabric_id"], name: "index_materials_on_fabric_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "material_id", null: false
    t.decimal "quantity", precision: 10, scale: 3, null: false
    t.string "state", default: "enabled", null: false
    t.datetime "reserved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales_channels", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "wholesale", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.date "starts_on"
    t.date "ends_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_seasons_on_code", unique: true
  end

  create_table "style_purchase_orders", force: :cascade do |t|
    t.string "po_number", null: false
    t.string "state", default: "created", null: false
    t.integer "style_id", null: false
    t.integer "vendor_id", null: false
    t.integer "sales_channel_id", null: false
    t.integer "owner_id", null: false
    t.integer "total_units", default: 0, null: false
    t.integer "total_cost_cents", default: 0, null: false
    t.datetime "sent_to_production_at"
    t.datetime "vendor_email_sent_at"
    t.string "netsuite_id"
    t.string "cancel_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_style_purchase_orders_on_owner_id"
    t.index ["po_number"], name: "index_style_purchase_orders_on_po_number", unique: true
    t.index ["sales_channel_id"], name: "index_style_purchase_orders_on_sales_channel_id"
    t.index ["state"], name: "index_style_purchase_orders_on_state"
    t.index ["style_id"], name: "index_style_purchase_orders_on_style_id"
    t.index ["vendor_id"], name: "index_style_purchase_orders_on_vendor_id"
  end

  create_table "styles", force: :cascade do |t|
    t.string "style_number", null: false
    t.string "name", null: false
    t.string "category"
    t.integer "season_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_styles_on_season_id"
    t.index ["style_number"], name: "index_styles_on_style_number", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "role", default: "viewer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name", null: false
    t.string "country_code", null: false
    t.string "lane", null: false
    t.string "email"
    t.string "netsuite_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "colorway_items", "colorway_styles"
  add_foreign_key "colorway_items", "style_purchase_orders"
  add_foreign_key "colorway_styles", "colorways"
  add_foreign_key "colorway_styles", "styles"
  add_foreign_key "cost_groups", "colorway_items"
  add_foreign_key "costs", "cost_groups"
  add_foreign_key "costs", "fabrics"
  add_foreign_key "costs", "vendors"
  add_foreign_key "event_logs", "users"
  add_foreign_key "fabrics", "vendors"
  add_foreign_key "materials", "colorway_items"
  add_foreign_key "materials", "fabrics"
  add_foreign_key "reservations", "materials"
  add_foreign_key "style_purchase_orders", "sales_channels"
  add_foreign_key "style_purchase_orders", "styles"
  add_foreign_key "style_purchase_orders", "users", column: "owner_id"
  add_foreign_key "style_purchase_orders", "vendors"
  add_foreign_key "styles", "seasons"
end
