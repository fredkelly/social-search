require 'spec_helper'

describe Clustering::DistanceMeasure do
  before(:all) do
    @measure = Clustering::DistanceMeasure.new
  end
  
  it 'should raise exception for non Enumerable' do
    expect { @measure.distance(1, 2) }.to raise_error
  end
  
  it 'should return zero for matching tokens' do
    @measure.distance(['hello'], ['hello']).should eq(0.0)
  end
end