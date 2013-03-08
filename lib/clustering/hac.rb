module Clustering
  # Hierarchical Agglomerative Clustering
  class HAC < Clusterer
    
    DELTA_THRESHOLD = 0.8
    
    # naive approach O(n^3)
    # http://www.graphics.cornell.edu/~bjw/IRT08Agglomerative.pdf
    def cluster!
      # start with everything in it's own cluster
      @clusters = @documents.map{|d| Cluster.new([d])}
      
      while @clusters.size > 1
        Rails.logger.info "@clusters.size = #{@clusters.size}"
        
        delta = Float::INFINITY
        left, right = nil
        
        # finds two closest documents
        @clusters.each do |a|
          @clusters.each do |b|
            if a != b and distance(a.tokens, b.tokens) < delta
              delta = distance(a.tokens, b.tokens)
              left, right = a, b
              Rails.logger.info "left = #{left}, right = #{right}, delta = #{delta}"
            end
          end
        end
        
        
        if delta < DELTA_THRESHOLD
          # merge closest two clusters
          @clusters << Cluster.new(left.documents + right.documents)
          @clusters.delete(left); @clusters.delete(right)
        else
          break
        end
      end
      
      @clusters
    end
    
  end
end