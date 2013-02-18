class AddRefererToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :referer, :string
    add_index :sessions, :referer
  end
end
