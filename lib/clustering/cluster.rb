require 'forwardable'

module Clustering
  class Cluster
    attr_accessor :documents, :centroid
    
    extend Forwardable
    def_delegator :@documents, :size
    
    # sets up cluster either with provided centroid or randomly selected one
    def initialize(documents, centroid = nil, options = {})
      @documents  = documents
      @centroid   = centroid # || @documents.sample
    end
    
    def tokens
      @documents.map(&:tokens).reduce(&:|)
    end
    
    # largest cluster first
    def <=>(other)
      other.documents.size <=> documents.size
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
    
    def urls
      @documents.map(&:expanded_urls).reduce(&:|)
    end
    
    def url
      urls.mode unless urls.empty?
    end
    
  end
end