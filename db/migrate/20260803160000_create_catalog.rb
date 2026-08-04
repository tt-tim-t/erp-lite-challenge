class CreateCatalog < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :role, null: false, default: "viewer"
      t.timestamps
    end
    add_index :users, :email, unique: true

    create_table :seasons do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.date :starts_on
      t.date :ends_on
      t.timestamps
    end
    add_index :seasons, :code, unique: true

    create_table :vendors do |t|
      t.string :name, null: false
      t.string :country_code, null: false
      t.string :lane, null: false
      t.string :email
      t.string :netsuite_id
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    create_table :sales_channels do |t|
      t.string :name, null: false
      t.boolean :wholesale, null: false, default: false
      t.timestamps
    end

    create_table :styles do |t|
      t.string :style_number, null: false
      t.string :name, null: false
      t.string :category
      t.references :season, null: false, foreign_key: true
      t.timestamps
    end
    add_index :styles, :style_number, unique: true

    create_table :colorways do |t|
      t.string :name, null: false
      t.string :color_code, null: false
      t.timestamps
    end

    create_table :colorway_styles do |t|
      t.references :style, null: false, foreign_key: true
      t.references :colorway, null: false, foreign_key: true
      t.string :status, null: false, default: "development"
      t.timestamps
    end
    add_index :colorway_styles, %i[style_id colorway_id], unique: true

    create_table :fabrics do |t|
      t.string :name, null: false
      t.string :fabric_type, null: false, default: "fabric"
      t.string :measurement_units, null: false, default: "yards"
      t.float :price
      t.references :vendor, foreign_key: true
      t.timestamps
    end
  end
end
