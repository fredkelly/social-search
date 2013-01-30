class RemoveEngineIdFromSearches < ActiveRecord::Migration
  def up
    remove_column :searches, :engine_id
  end

  def down
    add_column :searches, :engine_id, :integer
    add_index :searches, :engine_id
  end
end
