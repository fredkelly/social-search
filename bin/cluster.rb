# swap to extend Set?

class Cluster < Hash
  attr_reader :centroid
  
  def initialize(centroid = nil)
    @centroid = centroid
    super
  end
  
  def urls
    values.map(&:urls).flatten
  end

end