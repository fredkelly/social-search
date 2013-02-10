class Search < ActiveRecord::Base
  attr_accessible :query, :session_id, :engine_id
  
  belongs_to :session, touch: true
  has_many :results, dependent: :destroy
  
  validates :query, presence: true
  
  # create results as soon as record is created
  after_create :generate_results
  
  private
  
  # here we will call KMeans etc. to actually
  # generate some search results.
  def generate_results
    logger.info "Generating results for query: \"#{query}\"..."
    
    # results = (EngineA.results + EngineB.results).shuffle
    # results.each_with_index do |result, position|
    # ...
    # end
    
    Sorted.new(self)
  end
end
