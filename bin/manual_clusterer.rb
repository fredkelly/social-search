class ManualClusterer < Clusterer
  attr_reader :k
  
  def initialize(samples, k)
    @k = k
    @clusters ||= Array.new(@k) { Cluster.new }
    super(samples)
  end
  
  def cluster!(labels)
    @samples.each do |sample|
      if labels.has_key?(sample.id)
        @samples.delete(sample)
        @clusters[labels[sample.id]].add(sample)
      end
    end
  end
  
end