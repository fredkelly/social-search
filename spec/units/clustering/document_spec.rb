require 'spec_helper'

describe Clustering::Document do
  before(:all) do
    @documents = Twitter.search('google').statuses
  end
  
  it 'should subclass Twitter::Tweet' do
    @documents.first.is_a?(Twitter::Tweet).should be_true
  end
  
  it 'should alias to_s to text' do
    expect(@documents.first.to_s).to eq(@documents.first.text)
  end
  
  it 'should detect profanity' do
    document = Clustering::Document.new(id: 1, text: 'fuck')
    document.profane?.should be_true
  end
  
  it 'should be tokenisable' do
    @documents.first.should respond_to(:tokens)
  end
  
  it 'should parse hashtags' do
    @documents.first.should respond_to(:hashtags)
  end
  
  it 'should parse media_urls' do
    @documents.first.should respond_to(:media_urls)
  end
  
  it 'should parse expanded_urls' do
    @documents.first.should respond_to(:expanded_urls)
  end
  
  it 'should calculate time_delta' do
    @documents.first.should respond_to(:time_delta)
  end
end