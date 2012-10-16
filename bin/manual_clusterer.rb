class ManualClusterer < Clusterer
  attr_reader :k
  
  def initialize(samples, k = 5)
    @clusters ||= Array.new(@k = k) { Cluster.new }
    super(samples)
  end
  
  def cluster!(labels)
    @samples.each do |sample|
      if labels.has_key?(sample.id)
        @clusters[labels[sample.id]] << sample
      end
    end
  end
  
end