class AddTimeDeltaToResults < ActiveRecord::Migration
  def change
    add_column :results, :time_delta, :float
    
    Result.find_each do |r|
      r.time_delta ||= r.created_at
      r.save
    end
  end
end
