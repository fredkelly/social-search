require 'spec_helper'

describe Clustering::Tokeniser do
  it 'should remove stop words' do
    tokeniser = Clustering::Tokeniser.new(remove_stopwords: true)
    expect(tokeniser.tokenise(%q(and the us))).to eq([])
  end
  
  it 'should stem words' do
    tokeniser = Clustering::Tokeniser.new(stem: true)
    expect(tokeniser.tokenise(%q(changing running))).to eq(%w(chang run))
  end
  
  it 'should remove tokens shorter than limit' do
    tokeniser = Clustering::Tokeniser.new(limit: 7)
    expect(tokeniser.tokenise(%q(changing hello))).to eq(%w(changing))
  end
end