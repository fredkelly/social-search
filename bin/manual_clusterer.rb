# Provides a method of manually alocating
# samples to a given cluster via the web
# interface implemented by *views/manual.erb*
class ManualClusterer < Clusterer  
  # Creates a new instance of the Manual
  # clustering algorithm using supplied
  # data samples and k value.
  #
  # Creates k empty clusters initially.
  #
  # @param [Array] samples Array of <tt>Twitter::Tweet</tt> instances.
  #
  # @option options [Fixnum] k Number of clusters.
  #
  def initialize(samples, options = {})
    # create k empty clusters
    @clusters ||= Array.new(options[:k]) { Cluster.new }
    
    super(samples, options)
  end
  
  # Allocates samples to clusters using
  # supplied truth labels.
  #
  # @param [Array] labels Array of labels, where each key refers to the id of a
  #                       <tt>Twitter::Tweet</tt> instance in the samples array,
  #                       and each value is the index of a cluster (<= k).
  #
  def cluster!(labels)
    debug "Assigning samples using truth labels.."
    
    @samples.each do |sample|
      if labels.has_key?(sample.id)
        @clusters[labels[sample.id]] << sample
      end
    end
  end
  
  # WIP; comparison method between two clustering
  # algorithms (which have performed a clustering).
  # Matches each cluster using distance measure
  # then compares the nodes in matched clusters
  # to determine intersection/difference.
  #
  # @param [Clusterer] candidate Another <tt>Clusterer</tt> instance to compare to.
  #
  def compare_to(candidate)
    deltas = []
    
    # match up most similar clusters in candidate
    self.clusters.each_with_index do |src, i|
      # only look at non-empty clusters
      if src.size > 0
        # most similar by size of intersection
        sim = candidate.clusters.sort_by{|cand| (src & cand).size }.pop
      
        # %age of candidate cluster which is 'correct'
        deltas[i] = (src & sim).size.to_f / src.size
      end
    end
    
    # average delta
    deltas.reduce(&:+).to_f / deltas.size
  end
  
end