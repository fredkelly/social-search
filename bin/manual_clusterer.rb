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
  # @param [Clusterer] clusterer Another <tt>Clusterer</tt> instance to compare to.
  #
  def compare_to(clusterer)
    # deltas (set of wrongly classified tweets)
    deltas = []
    
    ext_clusters = clusterer.clusters.clone
    
    # match up clusters based on the distance between centroids.
    clusters.each_with_index do |t, i|
      # remove 'most similar' cluster
      comparable = ext_clusters.sort_by do |c|
        # distance between centroids
        # using distance measure for given clusterer
        clusterer.class.distance(t.centroid, c.centroid)
      end.shift
      
      # record delta
      deltas[i] = comparable - cluster
    end
    
    # print incorrect classifications?
    
    # return average delta size
    deltas.map(&:size).reduce(&:+).to_f / clustered_samples.size 
  end
  
end