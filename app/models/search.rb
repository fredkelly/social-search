class Search < ActiveRecord::Base
  attr_accessible :query, :session_id, :engine_id, :results_count
  
  belongs_to :session, touch: true
  has_many :results, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  delegate :empty?, to: :results
  
  validates :query, presence: true

  alias_attribute :to_s, :query
  
  scope :with_results, joins: :results, conditions: 'results.search_id IS NOT NULL', group: 'searches.id'
  scope :successful, joins: :results, conditions: 'results.selected_at IS NOT NULL'
  
  # statistics
  define_statistic :average_results, average: :all, column_name: :results_count
  define_calculated_statistic :percentage_successful do
    (successful.size / all.size).to_f
  end
  
  # gets recent search objects with results
  # ignores any duplicate query strings
  def self.recents(limit = 5)
    with_results.last(limit).uniq{|s| s.query}
  end
  
  def query_tokens
    @query_tokens ||= query.downcase.split
  end
  
  def successful?
    return false if results.empty?
    results.map(&:selected?).reduce(&:|)
  end
  
  # searches by same session within the last x mins
  def retried_from(since = 30.minutes.ago)
    session.searches.where('id != ?', id).where(created_at: since..created_at)
  end
  
  def retried?
    !retried_from.empty?
  end

end
