module Clustering
  class MajorClust < Clusterer
    
    # MajorClust implementation
    def cluster!
      # put every document in it's own cluster
      @documents.each do |document|
        @clusters << Cluster.new(document)
      end
      
      ready = false
      
      while not ready
        ready = true
        
        @documents.each do |q|
          
        end
      end
      
      @clusters
    end
    
  end
end