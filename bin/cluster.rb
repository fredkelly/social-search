# specific dependencies
require './bin/result.rb'
require 'forwardable'
require 'set'

# Models a clustering of nodes produced
# by an instance of Clusterer. Members are
# stored in the +samples+ instance variable, common
# Set methods are also delagated to it directly.
class Cluster < Result
  attr_accessor :centroid, :samples
  
  extend Forwardable
  def_delegators :samples, :size, :<<, :add, :map, :each, :to_a, :&, :-, :+
  def_delegators :page, :title, :description, :nil?
  
  # initializes a new cluster, usually called
  # to create an empty Set at the start of the
  # given clustering algorithm. Samples uses
  # a Set to ensure samples are distinct.
  #
  # @param [Twitter::Tweet] centroid The centroid of the cluster.
  #
  def initialize(centroid = nil)
    @samples = Set.new
    @centroid = centroid
  end
  
  # Collects all the URLs belonging to Tweets
  # contained in the cluster (returned as strings).
  def urls
    samples.map(&:urls).flatten
  end
  
  # WIP; Get the most frequently occuring URL.
  def url
    urls.group_by{|url| url}.values.max_by(&:size).first rescue nil
  end
  
  private
  
  def page
    @page ||= (Page.get(url) rescue nil) unless url.nil?
  end
  
end