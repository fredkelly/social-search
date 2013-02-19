class ChangeRemoteAddrToRemoteIpInSessions < ActiveRecord::Migration
  def up
    rename_column :sessions, :remote_addr, :remote_ip
  end

  def down
    rename_column :sessions, :remote_ip, :remote_addr
  end
end
