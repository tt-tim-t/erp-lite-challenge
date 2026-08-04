class CreateStylePurchaseOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :style_purchase_orders do |t|
      t.string :po_number, null: false
      t.string :state, null: false, default: "created"
      t.references :style, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true
      t.references :sales_channel, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.integer :total_units, null: false, default: 0
      t.integer :total_cost_cents, null: false, default: 0
      t.datetime :sent_to_production_at
      t.datetime :vendor_email_sent_at
      t.string :netsuite_id
      t.string :cancel_reason
      t.timestamps
    end
    add_index :style_purchase_orders, :po_number, unique: true
    add_index :style_purchase_orders, :state

    create_table :colorway_items do |t|
      t.references :style_purchase_order, null: false, foreign_key: true
      t.references :colorway_style, null: false, foreign_key: true
      t.string :status, null: false, default: "active"
      t.string :cost_sheet_state, null: false, default: "draft"
      t.integer :units_requested, null: false, default: 0
      t.integer :units_received, null: false, default: 0
      t.integer :unit_cost_cents, null: false, default: 0
      t.integer :extended_cost_cents, null: false, default: 0
      t.date :original_delivery_date
      t.date :revised_delivery_date
      t.datetime :cost_sheet_locked_at
      t.timestamps
    end
  end
end
