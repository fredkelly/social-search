class StatisticsAggregate < ActiveRecord::Base
  attr_accessible :comments_average_rating, :results_average_selected_position,
                  :results_average_selections, :results_average_time_to_select,
                  :searches_average_results, :searches_percentage_successful,
                  :sessions_percentage_returning
  
  before_create :collect_statistics
  
  scope :this_week, where('created_at >= ?', 7.days.ago)
  default_scope order: 'created_at ASC'
  
  IGNORED_COLUMNS = %w(id created_at updated_at)
  
  def self.as_time_series(scope = :this_week)
    series = {}
    data = send(scope)
    (column_names - IGNORED_COLUMNS).map(&:to_sym).each do |column|
      series[column] = data.map(&column)
    end
    series
  end
  
  def collect_statistics(since = 1.day.ago)
    [Search, Result, Session, Comment].each do |model|
      model.where(created_at: since..0.ago).statistics.each do |key, value|
        write_attribute("#{model.table_name}_#{key}", value.to_f)
      end
    end
  end
end