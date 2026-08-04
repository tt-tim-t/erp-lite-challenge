class CreateMaterialsAndReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :materials do |t|
      t.references :colorway_item, null: false, foreign_key: true
      t.references :fabric, null: false, foreign_key: true
      t.string :use, null: false, default: "body"
      t.decimal :estimated_yield, precision: 8, scale: 3, null: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    create_table :reservations do |t|
      t.integer :material_id, null: false
      t.decimal :quantity, precision: 10, scale: 3, null: false
      t.string :state, null: false, default: "enabled"
      t.datetime :reserved_at
      t.timestamps
    end
    add_foreign_key :reservations, :materials
  end
end
