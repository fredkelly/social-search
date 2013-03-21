require 'forwardable'

module Clustering
  # base class to be extended by various clustering algorithms
  class Clusterer
    attr_reader :clusters
    
    extend Forwardable
    def_delegator :@measure, :distance
    
    def initialize(documents, options = {})
      @documents = documents
      @options   = options
      @clusters  = []
      @measure   = DistanceMeasure.new(options[:measure])
      @logger    = ActiveSupport::BufferedLogger.new(log_path)
      
      debug "Initialised #{self.class} with #{documents.size} documents."
    end
    
    def cluster
      raise NotImplementedError, "#{self.class}.#{__method__} must be implemented in subclass"
    end
    
    # assume non-destructive by default
    # e.g. incase we wan't compare implementations in parallel etc.
    def cluster!
      @clusters = cluster
    end
    
    private
    
    # log helper
    def debug(message)
      @logger.info(message)
    end
    
    def debug_clusters(clusters = @clusters)
      clusters.each do |cluster|
        unless cluster.url.nil?
          debug (title = "\nCluster (#{cluster.url}):") + "\n" + ('-' * title.size)
          cluster.documents.map{|d| debug "\t#{d.text.split[0..15].join(' ')}..."}
        end
      end
    end
    
    def log_path
      Rails.root.join("log/#{self.class}.log".gsub('::', '_'))
    end
    
  end
end