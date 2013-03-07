require 'forwardable'

module Clustering
  # base class to be extended by various clustering algorithms
  class Clusterer
    attr_reader :clusters
    
    extend Forwardable
    def_delegator :@measure, :distance
    
    def initialize(documents, options = {})
      @documents = documents
      @clusters  = []
      @measure   = DistanceMeasure.new(options[:measure])
    end
    
  end
end