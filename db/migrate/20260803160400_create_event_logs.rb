class CreateEventLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :event_logs do |t|
      t.references :event_source, polymorphic: true, null: false
      t.references :user, foreign_key: true
      t.string :event, null: false
      t.json :details
      t.datetime :created_at, null: false
    end
  end
end
