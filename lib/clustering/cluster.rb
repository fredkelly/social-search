module Clustering
  class Cluster
    attr_reader :documents, :centroid
    
    # sets up cluster either with provided centroid or randomly selected one
    def initialize(documents, centroid = nil, options = {})
      @documents = Array(documents)
      @centroid  = centroid || @documents.sample
      @options   = options
    end
  end
end