class StatisticsAggregate < ActiveRecord::Base
  attr_accessible :comments_average_rating, :results_average_selected_position,
                  :results_average_selections, :results_average_time_to_select,
                  :searches_average_results, :searches_percentage_successful,
                  :sessions_percentage_returning
  
  before_create :collect_statistics
  
  scope :this_week, where('created_at >= ?', 7.days.ago)
  default_scope order: 'created_at ASC'
  
  IGNORED_COLUMNS = %w(id created_at updated_at)
  
  # friendly names for columns
  FRIENDLY_NAMES = {
    :comments_average_rating => "Rating (via Comments)",
    :results_average_selected_position => "Position of Selected Results",
    :results_average_selections => "No. of Selected Results",
    :results_average_time_to_select => "Time Taken to Select a Result",
    :searches_average_results => "Results per Search",
    :searches_percentage_successful => "% Successful Searches",
    :sessions_percentage_returning => "% Returning Visitors"
  }
  
  # only one aggregation/date
  def unique_date
    unless self.class.where('date(created_at) = ?', Date.today).empty?
      errors.add(:created_at, "date must be unique")
    end
  end
  validate :unique_date
  
  def self.as_time_series(scope = :this_week)
    series = {}
    data = send(scope)
    (column_names - IGNORED_COLUMNS).map(&:to_sym).each do |column|
      series[column] = data.map(&column)
    end
    series
  end
  
  # should be relative to created_at if exists?
  def collect_statistics(since = 1.day.ago)
    [Search, Result, Session, Comment].each do |model|
      model.where(created_at: since..0.ago).statistics.each do |key, value|
        write_attribute("#{model.table_name}_#{key}", value.to_f)
      end
    end
  end
end
