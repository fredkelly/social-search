# 'Abstract' class modelling a clustering algorithm.
# Acts as a placeholder for inputs (+samples+) and resulting
# groupings (+clusters+). Methods which are required in
# ancestor classes raise a <tt>NotImplementedError</tt> if
# called without override in child class.
class Clusterer
  attr_accessor :samples, :clusters, :options
  
  # Creates a new instance of given clustering
  # algorithm taking an array of sample data
  # on which the clustering will be performed.
  #
  # @param [Array] samples Array of <tt>Twitter::Tweet</tt> instances.
  #
  # @option options [Boolean] verbose Whether to show debugging info.
  #
  def initialize(samples, options = {})
    @options  = options
    @samples  = samples
    @clusters ||= [] # don't overwrite existing clusters
    
    debug "Initialised #{self.class} with #{samples.size} samples, options: #{options}.."
  end
  
  # The meat of the clustering algorithm, to
  # be implemented in the ancestor class.
  # Raises <tt>NotImplementedError</tt> if
  # superclass implementation is called.
  #
  def cluster!
    # perform clustering here..
    raise NotImplementedError.new("Clustering not implemented!")
  end
  
  # Provides the distance measurment for given
  # clustering algorithm; return values in range
  # 0.0 - 1.0 represent the distance between a and b
  # e.g. a value of 0.0 indicates a == b.
  #
  # Although initially <tt>a</tt> and <tt>b</tt> both represent
  # strings, later implementations may pass objects with multiple
  # feature vectors to be used in the distance calculation.
  #
  # @param [String] a First string.
  # @param [String] b Second string.
  #
  def self.distance(a, b)
    # distance measure
    raise NotImplementedError.new("Distance measure not implemented!")
  end
  
  # Helper method for use during testing;
  # returns all the classified samples in a given set.
  # Allows direct comparisions between two
  # classifications based on the same sample set.
  def clustered_samples
    @clusters.map(&:to_a).flatten
  end
  
  # Helper method for returning unclassified samples
  # for use in ManualClusterer web UI.
  def remaining_samples
    samples - clustered_samples
  end
  
  # Saves <tt>Clusterer</tt> instance directly
  # to disk using object marshalling.
  #
  # @param [String] file_name Path where file will be saved.
  #
  def save(file_name = @file_name)
    @file_name = file_name # update in case changed
    File.open(@file_name, 'w') do |file|
      Marshal.dump(self, file)
    end
  end
  
  # Loads <tt>Clusterer</tt> instance directly
  # from disk using object marshalling.
  #
  # @param [String] file_name Path where file will be saved.
  #
  def self.load(file_name)
    File.open(file_name, 'r') do |file|
      Marshal.load(file)
    end rescue nil
  end
  
  # Outputs debugging information if verbose is on.
  #
  # @param [String] message Message to output.
  def debug(message)
    puts message if @options[:verbose]
  end
  
  # Returns descendant classes, based on code
  # from this question[koverflow.com/questions/2393697/look-up-all-descendants-of-a-class-in-ruby].
  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end
  
  # Easy accessor for options[:k]
  def k
    @options[:k] if @options.has_key?(:k)
  end
  
end