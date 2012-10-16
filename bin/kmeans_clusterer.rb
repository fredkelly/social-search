require 'levenshtein'
require 'benchmark'

class KMeans < Clusterer
  
  def initialize(samples, k = 5)
    # randomly select centroids
    @clusters ||= samples.sample(@k = k).map { |c| Cluster.new(c) }
    super(samples)
  end
  
  def cluster!
    puts "Clustering.."
    
    while true
      
      # for each sample
      @samples.each do |sample|
        # add to the closest cluster
        @clusters.sort_by{|c| self.class.distance(c.centroid.text, sample.text)}.first << sample # remove?
      end
      
      # recentre centroids
      max_delta = -Float::INFINITY
      time = Benchmark.measure do
        @clusters.each do |cluster|
          delta = self.class.centre!(cluster)
        
          if delta > max_delta
            max_delta = delta
          end
        end
      end
      
      puts "Re-centring time: #{time}"
      puts "max_delta = #{max_delta}"
      
      # exit condition
      if max_delta > 0.9
        break
      end

    end
    
  end
  
  # re-centre given cluster's centroid
  def self.centre!(cluster)
    old_centroid = cluster.centroid
    
    # take most occuring words
    words = {}
    time = Benchmark.measure do
      cluster.each do |sample|
        sample.tokens.each do |token|
          words[token] = words[token].to_i + 1
        end
      end
    end
    
    puts "Centroid creation time: #{time}"
    
    # create new string
    target = Hash[words.sort_by{|k,v| -v}].keys[0..10].join(' ')
    
    puts "Creating new centroid: #{target}"
    
    # find closest sample and assign
    cluster.centroid = cluster.samples.sort_by{|sample| distance(sample.text, target)}.first
    
    distance(old_centroid.text, cluster.centroid.text)
  end
  
  def self.distance(a, b)
    Levenshtein.normalized_distance(a, b)
  end
  
end