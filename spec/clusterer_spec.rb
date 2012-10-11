require './bin/clusterer.rb'

describe Clusterer do
  it "should initially have no clusters" do
    Clusterer.new.clusters.should == []
  end
end