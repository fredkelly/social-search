require './bin/classifier.rb'

describe Classifier do
  it "should initially have no clusters" do
    Classifier.new.clusters.should == []
  end
end