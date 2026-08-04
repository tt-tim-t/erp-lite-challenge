class CreateCostSheets < ActiveRecord::Migration[8.0]
  def change
    create_table :cost_groups do |t|
      t.references :colorway_item, null: false, foreign_key: true
      t.string :group_type, null: false
      t.integer :extended_value_sum_cents, null: false, default: 0
      t.timestamps
    end
    add_index :cost_groups, %i[colorway_item_id group_type], unique: true

    create_table :costs do |t|
      t.references :cost_group, null: false, foreign_key: true
      t.references :vendor, foreign_key: true
      t.references :fabric, foreign_key: true
      t.string :name, null: false
      t.integer :base_value_cents, null: false, default: 0
      t.decimal :loss_rate, precision: 5, scale: 4, null: false, default: 0
      t.integer :extended_value_cents, null: false, default: 0
      t.integer :actualized_value_cents
      t.datetime :po_triggered_at
      t.timestamps
    end
  end
end
