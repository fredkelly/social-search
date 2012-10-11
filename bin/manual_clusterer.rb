class ManualClusterer < Clusterer
  def initialize(samples, labels)
    n = labels.values.max + 1
    @clusters = Array.new(n) { Array.new }
    samples.each do |sample|
      if labels.has_key?(sample.id)
        @clusters[labels[sample.id]] << sample
      end
    end
  end
end