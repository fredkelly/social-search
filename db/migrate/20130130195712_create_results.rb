class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :title
      t.string :url
      t.integer :search_id
      t.string :description
      t.datetime :selected_at
      t.integer :position
      t.string :source_engine

      t.timestamps
    end
    add_index :results, :search_id
    add_index :results, :source_engine
  end
end
