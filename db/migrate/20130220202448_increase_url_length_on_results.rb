class IncreaseUrlLengthOnResults < ActiveRecord::Migration
  def up
    change_column :results, :url, :text # allow for > 255 char urls!
  end

  def down
    change_column :results, :url, :string
  end
end
