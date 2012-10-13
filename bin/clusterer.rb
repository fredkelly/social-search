class Clusterer
  attr_reader :samples, :clusters
  
  def initialize(samples)
    @samples  = samples
    @clusters ||= []
  end
  
  def cluster!
    # perform clustering here..
    raise NotImplementedError.new("Clustering not implemented!")
  end
  
  # add load/save methods here
  # instead of having them on Twitter?
  
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
end