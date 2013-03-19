class AddTimeDeltaToResults < ActiveRecord::Migration
  def change
    add_column :results, :time_delta, :float
  end
end
