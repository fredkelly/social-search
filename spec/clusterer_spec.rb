require './bin/clusterer.rb'

describe Clusterer do
  
  it "should initially have no clusters" do
    Clusterer.new([]).clusters.should == []
  end
  
  it "should raise exception if samples are invalid" do
    expect { Clusterer.new(nil) }.to raise_error(ArgumentError)
  end
  
  it "should set it's options hash" do
    options = { :these => 'are', :some => 'options' }
    Clusterer.new([], options).options.should == options
  end
  
  it "should have accessible k value" do
    options = { :k => 7 }
    Clusterer.new([], options).k.should == options[:k]
  end
  
  it "should load/save from file" do
    file_name = './stash/clusterer_spec_test.stash'
    (saved = Clusterer.new([])).save(file_name)
    Clusterer.load(file_name).should == saved
    File.delete(file_name) # delete test stash
  end
  
  it "should output debug messages with verbose enabled" do
    message = "this is a test message."
    clusterer = Clusterer.new([], :verbose => true)
    $stdout.should_receive(:puts).with(message)
    clusterer.debug(message)
  end
  
  it "should not intersect clustered & non-clustered samples" do
    clusterer = Clusterer.new([])
    (clusterer.clustered_samples & clusterer.remaining_samples).should == []
  end
  
  it "should raise exception calling #cluster!" do
    expect { Clusterer.new([]).cluster! }.to raise_error(NotImplementedError)
  end
  
  it "should raise exception calling self#distance" do
    expect { Clusterer.distance(nil, nil) }.to raise_error(NotImplementedError)
  end
  
  it "should raise exception when loading invalid files" do
    expect { Clusterer.load('sdfsadasd') }.to raise_error(Errno::ENOENT)
  end
  
end