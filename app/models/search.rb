class Search < ActiveRecord::Base
  attr_accessible :query, :session_id, :engine_id
  
  belongs_to :session, touch: true
  has_many :results, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  validates :query, presence: true
  
  # create results as soon as record is created
  after_create :generate_results
  
  alias_attribute :to_s, :query
  
  scope :with_results, joins: [:results], conditions: 'results.search_id IS NOT NULL', group: 'searches.id'
  
  # gets recent search objects with results
  # ignores any duplicate query strings
  def self.recents(limit = 5)
    with_results.last(limit).uniq{|s| s.query}
  end
  
  def query_tokens
    @query_tokens ||= query.downcase.split
  end
  
  def success?
    return false if results.empty?
    results.map(&:selected?).reduce(&:|)
  end
  
  private
  
  # here we will call KMeans etc. to actually
  # generate some search results.
  def generate_results
    TestEngine.new(self)
  end
end
