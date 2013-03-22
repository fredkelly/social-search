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
  
  it 'should downcase words' do
    tokeniser = Clustering::Tokeniser.new(downcase: true)
    expect(tokeniser.tokenise(%q(Happy))).to eq(%w(happy))
  end
  
  it 'should selectivly remove POS tags' do
    tokeniser = Clustering::Tokeniser.new(keep_only_tags: %w(VBD))
    expect(tokeniser.tokenise(%q(Fred walked home))).to eq(%w(walked))
  end
  
  it 'should detect invalid POS tags' do
    tokeniser = Clustering::Tokeniser.new(keep_only_tags: %w(FOO))
    expect { tokeniser.tokenise(%q(this should fail)) }.to raise_error
  end
end