require 'spec_helper'

describe Clustering::Cluster do
  before(:all) do
    @cluster = Clustering::Cluster.new([])
  end
  
  it 'should randomly pick centroid if not supplied' do
    documents = ('a'..'z').to_a
    cluster = Clustering::Cluster.new(clusters, nil)
    documents.should include(cluster.centroid)
  end
  
  it 'should compare based on cluster size' do
    a, b, = Clustering::Cluster.new((1..5).to_a), Clustering::Cluster.new((1..10).to_a)
    (a < b).should be_true
  end
  
  it 'should be tokenisable' do
    @cluster.should respond_to(:tokens)
  end
  
  it 'should provide a to_s' do
    @cluster.should respond_to(:to_s)
    @cluster.to_s.is_a?(String).should be_true
  end
  
  it 'should parse hashtags' do
    @cluster.should respond_to(:hashtags)
  end
  
  it 'should parse media_urls' do
    @cluster.should respond_to(:media_urls)
  end
  
  it 'should parse urls' do
    @cluster.should respond_to(:urls)
  end
  
  it 'should calculate time_delta' do
    @cluster.should respond_to(:time_delta)
  end
end