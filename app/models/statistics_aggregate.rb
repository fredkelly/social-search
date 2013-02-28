class StatisticsAggregate < ActiveRecord::Base
  attr_accessible :comments_average_rating, :results_average_selected_position,
                  :results_average_selections, :results_average_time_to_select,
                  :searches_average_results, :searches_percentage_successful,
                  :sessions_percentage_returning
  
  before_create :collect_statistics
  
  def collect_statistics(since = 1.day.ago)
    [Search, Result, Session, Comment].each do |model|
      model.where(created_at: since..0.ago).statistics.each do |key, value|
        write_attribute("#{model.table_name}_#{key}", value)
      end
    end
  end
end
