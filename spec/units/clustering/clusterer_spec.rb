require 'spec_helper'

describe Clustering::Clusterer do
  before(:all) do
    @clusterer = Clustering::Clusterer.new([])
  end
  
  it 'must provide a cluster method' do
    @clusterer.should respond_to(:cluster)
  end
  
  it 'clusters must be publc' do
    @clusterer.should respond_to(:clusters)
  end
  
  it 'must raise error if cluster is called on superclass' do
    expect { @clusterer.cluster }.to raise_error
  end
end