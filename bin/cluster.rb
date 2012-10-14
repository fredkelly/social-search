require 'set'

class Cluster < Set
  attr_accessor :centroid
  
  def urls
    to_a.map(&:urls).flatten
  end
  
end