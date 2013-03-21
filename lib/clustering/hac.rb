module Clustering
  # Hierarchical Agglomerative Clustering
  class HAC < Clustering::Clusterer
    
    IMPLEMENTATION = :cluster_sorted
    DELTA_THRESHOLD = 0.95 # lower => more separation
    
    SCRAPED = true
    
    def cluster
      debug "Began clustering..."
      self.send(IMPLEMENTATION, @clusters)
    end
    
    # naive approach O(n^3)
    def cluster_naive(clusters)
      
      # start with everything in it's own cluster (no centroid)
      clusters = @documents.map{|d| Cluster.new([d], nil)}
      
      while clusters.size > 1        
        min_delta = Float::INFINITY
        left, right = nil
        
        # loop through all pairs of clusters
        clusters.each do |a|
          clusters.each do |b|
            if a != b and (delta = distance(a.tokens, b.tokens)) < min_delta
              min_delta = delta
              left, right = a, b
            end
          end
        end
                
        if min_delta < DELTA_THRESHOLD
          # merge closest two clusters
          clusters << Cluster.new(left.documents + right.documents)
          clusters.delete(left); clusters.delete(right)
        else
          break
        end
      end
      
      clusters      
    end
    
    # improved complexity
    def cluster_sorted(clusters)
      
      # start with everything in it's own cluster
      clusters = @documents.map{|d| Cluster.new([d])}
      
      while clusters.size > 1
        # closest pair of clusters clusters
        left, right, delta = clusters.combination(2).map{|a,b| [a,b,distance(a.tokens,b.tokens)]}.min_by(&:last)
                
        if delta < DELTA_THRESHOLD
          debug "Merging clusters\n\t#{left}\n\t#{right}"
          
          # merge closest two clusters
          clusters << Cluster.new(left.documents + right.documents)
          clusters.delete(left); clusters.delete(right)
        else
          debug "Threshold reached (#{delta}), ending clustering."
          
          break
        end
      end
      
      # print out clusters
      debug_clusters(clusters)
      
      clusters      
    end
    
  end
end