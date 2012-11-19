# Implements the K-means[link:http://en.wikipedia.org/wiki/K-means_clustering] clustering algorithm.
# using Levenshtein distance measure and
# Pseudo string generation for centroid recentring.
class KMeans < Clusterer
  # Creates a new instance of the K-means
  # clustering algorithm using supplied
  # data samples and k value.
  #
  # Picks k centroids randomly from
  # supplied data samples.
  #
  # @param [Array] samples Array of <tt>Twitter::Tweet</tt> instances.
  #
  # @option options [Fixnum] k Number of clusters.
  #
  def initialize(samples, options)    
    # randomly select centroids
    @clusters ||= samples.sample(options[:k]).map { |c| Cluster.new(c) }
    
    super(samples, options)
  end
  
  # Performs the cluster assignment,
  # each sample is added to the cluster
  # with the closest centroid.
  #
  # Centring will repeat until delta
  # threshold is reached.
  #
  def cluster!
    for i in 0..@options[:iterations]-1 # maximum of X iterations
      debug "Beginning k-means iteration #{i}:"
      
      # for each sample
      @samples.each do |sample|
        # add to the closest cluster
        @clusters.sort_by{|c| self.class.distance(c.centroid.tokens, sample.tokens)}.first << sample # remove?
      end
      
      # recentre centroids
      max_delta = -Float::INFINITY
      @clusters.each do |cluster|
        delta = self.class.centre!(cluster)
        
        if delta > max_delta
          max_delta = delta
        end
      end
      
      debug "max_delta = #{max_delta}"
      
      # exit condition
      if max_delta > @options[:threshold]
        break
      end
    end
  end
  
  # Re-centres given cluster's centroid
  # uses word occurance to re-generate
  # a new string to act as the new centroid
  #
  # Implemented as a static method within
  # the clusterer class rather than a method
  # on the centroid in order to keep all
  # aspects of classification (algorithms etc)
  # in a single class/file.
  #
  # @param [Cluster] cluster The cluster to be re-centred.
  #
  def self.centre!(cluster)    
    # save current centroid
    old_centroid = cluster.centroid
    
    # take most occuring words
    words = {}
    cluster.each do |sample|
      sample.tokens.each do |token|
        words[token] = words[token].to_i + 1 if token.size > 3 # ignore shorter words
      end
    end
        
    # create new string
    cluster.centroid = Centroid.new(words.sort_by{|k,v| v}[-[10, words.size].min..-1].map(&:first))
        
    # return delta
    distance(old_centroid.tokens, cluster.centroid.tokens)
  end
  
  # Returns a float between 0.0 and 1.0
  # representing the token difference
  # between token arrays a and b.
  #
  # @param [Array] a First tokens.
  # @param [Array] b Second tokens.
  #
  def self.distance(a, b)
    #Levenshtein.normalized_distance(a, b)
    1.0 - (a & b).size.to_f / (a + b).size
  end
  
end