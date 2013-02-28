class CreateStatisticsAggregates < ActiveRecord::Migration
  def change
    create_table :statistics_aggregates do |t|
      t.float :searches_average_results
      t.float :searches_percentage_successful
      t.float :results_average_selections
      t.float :results_average_selected_position
      t.float :results_average_time_to_select
      t.float :sessions_percentage_returning
      t.float :comments_average_rating

      t.timestamps
    end
  end
end
