class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :query
      t.integer :engine_id
      t.integer :session_id

      t.timestamps
    end
    add_index :searches, :engine_id
    add_index :searches, :session_id
  end
end
