class AddTimeDeltaToResults < ActiveRecord::Migration
  def change
    add_column :results, :time_delta, :float
    
    # quick fix for old results
    now = Time.now
    Result.find_each do |r|
      r.update_attribute(:time_delta, now - r.created_at) if r.read_attribute(:time_delta).nil?
    end
  end
end
