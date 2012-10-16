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
  
  def self.distance(a, b)
    # distance measure
    raise NotImplementedError.new("Distance measure not implemented!")
  end
  
  # return all samples for testing
  def clustered_samples
    @clusters.map(&:samples).flatten
  end
  
  def save(file_name = @file_name)
    @file_name = file_name # update in case changed
    File.open(@file_name, 'w') do |file|
      Marshal.dump(self, file)
    end
  end
  
  # load from file or return nil
  def self.load(file_name)
    File.open(file_name, 'r') do |file|
      Marshal.load(file)
    end rescue nil
  end
  
  def -(clusterer)
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