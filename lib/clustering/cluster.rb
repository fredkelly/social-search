module Clustering
  class Cluster
    attr_accessor :documents, :centroid
    
    # sets up cluster either with provided centroid or randomly selected one
    def initialize(documents, centroid = nil, options = {})
      @documents  = documents
      @centroid   = centroid # || @documents.sample
    end
    
    def tokens
      @documents.map(&:tokens).flatten.uniq
    end
    
  end
end