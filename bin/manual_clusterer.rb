class ManualClusterer < Clusterer
  attr_reader :k
  
  def initialize(samples, k)
    @clusters ||= Array.new(@k = k) { Cluster.new }
    super(samples)
  end
  
  def cluster!(labels)
    @samples.each do |sample|
      if labels.has_key?(sample.id)
        @clusters[n = labels[sample.id]] << sample # @samples.delete(sample)
        puts "Moving \"#{sample}\" (#{sample.id}) to cluster ##{n}.."
      end
    end
  end
  
end