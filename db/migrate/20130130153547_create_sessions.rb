class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :session_id
      t.string :remote_ip
      t.string :accept_language
      t.string :user_agent
      t.string :accept_charset
      t.string :accept

      t.timestamps
    end
    add_index :sessions, :session_id
  end
end
