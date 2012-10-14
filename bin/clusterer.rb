class Clusterer
  attr_accessor :samples, :clusters
  
  def initialize(samples)
    @samples  = samples
    @clusters ||= []
  end
  
  def cluster!
    # perform clustering here..
    raise NotImplementedError.new("Clustering not implemented!")
  end
  
  # return all samples for testing
  def clustered_samples
    @clusters.map(&:to_a).flatten
  end

  def save(file_name = @file_name)
    @file_name ||= file_name
    File.open(@file_name, 'w') do |file|
      Marshal.dump(self, file)
    end
  end
  
  def self.load(file_name)
    File.open(file_name, 'r') do |file|
      Marshal.load(file)
    end
  end
    
  # add comparison methods
  # e.g. difference in clustering
  # (for use with equal datasets)
  
  def compare_to(clusterer)
    # 0. delta[clusters.size] = 0
    # 1. match up clusters based on the distance between centroids.
    # 2. for each cluster
    # 3.  delta += self.cluster \ new.cluster
  end
end