class AddTimeDeltaToResults < ActiveRecord::Migration
  def change
    add_column :results, :time_delta, :float, default: 0.0
  end
end
