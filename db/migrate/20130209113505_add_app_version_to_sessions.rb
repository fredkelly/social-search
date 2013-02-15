class AddAppVersionToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :app_version, :datetime
    add_index :sessions, :app_version
  end
end
