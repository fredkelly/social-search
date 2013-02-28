class AddResultsCountToSearches < ActiveRecord::Migration
  def up
    add_column :searches, :results_count, :integer, default: 0
    
    # reset col info
    Search.reset_column_information
    
    # update counts for existing searches
    Search.all.each do |s|
      s.update_attribute :results_count, s.results.length
    end
  end
  
  def down
    remove_column :searches, :results_count
  end
end
