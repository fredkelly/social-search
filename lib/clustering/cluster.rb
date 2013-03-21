require 'forwardable'

module Clustering
  class Cluster
    attr_accessor :documents, :centroid
    
    extend Forwardable
    def_delegator :@documents, :size
    
    include Comparable
    
    # sets up cluster either with provided centroid or randomly selected one
    def initialize(documents, centroid = nil, options = {})
      @documents  = documents
      @centroid   = centroid || @documents.sample
      @options    = options
    end
    
    def tokens
      Array @documents.map(&:tokens).reduce(&:|)
    end
    
    # largest cluster first
    def <=>(other)
      other.documents.size <=> documents.size
    end
    
    def hashtags
      Array @documents.map(&:hashtags).reduce(&:|)
    end
    
    def media_urls
      Array @documents.map(&:media_urls).reduce(&:|)
    end
    
    def has_media?
      !media_urls.empty?
    end
    
    def urls
      Array @documents.map(&:expanded_urls).reduce(&:|)
    end
    
    def url
      urls.mode unless urls.empty?
    end
    
    def time_delta
      @documents.map(&:time_delta).mean
    end
    
    def to_s
      "#<#{self.class}: size=#{@documents.size}, hashtags=[#{hashtags.join(',')}]>"
    end
    
  end
end