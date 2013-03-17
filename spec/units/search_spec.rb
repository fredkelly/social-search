require 'spec_helper'

describe Search do
  fixtures :sessions
  
  it 'validates presence of query' do
    search = Search.new
    search.valid?.should be_false
  end
  
  it 'is empty by default' do
    search = Search.new(query: 'Test')
    search.empty?.should be_true
  end
  
  it 'should tokenise query' do
    search = Search.new(query: 'This is a Long Query')
    expect(search.query_tokens).to eq(%w(this is a long query))
  end

end