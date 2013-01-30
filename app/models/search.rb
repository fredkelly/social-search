class Search < ActiveRecord::Base
  attr_accessible :query, :session_id, :engine_id
  
  belongs_to :session
  
  validates :query, presence: true
  
  # create results as soon as record is created
  after_create :generate_results
  
  private
  
  # here we will call KMeans etc. to actually
  # generate some search results.
  def generate_results
    # results = ...
  end
end
