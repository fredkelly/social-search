require 'forwardable'
require 'set'

class Cluster
  extend Forwardable
  def_delegators :@samples, :size, :<<, :add, :map, :each
  
  attr_accessor :centroid, :samples
  
  # override to set centroid
  def initialize(centroid = nil)
    @samples = Set.new
    @centroid = centroid
  end
  
  def urls
    samples.map(&:urls).flatten
  end
  
end