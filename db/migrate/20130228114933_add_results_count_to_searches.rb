class AddResultsCountToSearches < ActiveRecord::Migration
  def up
    add_column :searches, :results_count, :integer, default: 0
    
    # reset col info
    Search.reset_column_information
    
    # update counts for existing searches
    Search.find_each do |s|
      Search.reset_counters s.id, :results
    end
  end
  
  def down
    remove_column :searches, :results_count
  end
end
