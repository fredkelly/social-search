class AddGeocodingToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :longitude, :float
    add_column :sessions, :latitude, :float
    
    # geocode all existing records
    Session.all.map{|s| s.geocode; s.save}
  end
end
