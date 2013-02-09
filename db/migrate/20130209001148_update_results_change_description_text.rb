class UpdateResultsChangeDescriptionText < ActiveRecord::Migration
  def up
    change_column :results, :description, :text
  end

  def down
    change_column :results, :description, :string
  end
end
