module Clustering
  class Cluster
    attr_accessor :documents, :centroid
    
    # sets up cluster either with provided centroid or randomly selected one
    def initialize(documents, centroid = nil, options = {})
      @documents  = documents
      @centroid   = centroid # || @documents.sample
    end
    
    def tokens
      @documents.map(&:tokens).reduce(&:|)
    end
    
    def <=>(other)
      documents.size <=> other.documents.size
    end
    
    def hashtags
      @documents.map(&:hashtags).reduce(&:|)
    end
    
    def media_urls
      @documents.map(&:media_urls).reduce(&:|)
    end
    
    def has_media?
      !media_urls.empty?
    end
    
  end
end