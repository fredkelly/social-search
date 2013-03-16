require 'spec_helper'

describe Page do
  
  it 'resolves redirects' do
    page = Page.get 'http://bit.ly/cOjw9m'
    expect(page.url).to eq('https://www.google.co.uk/')
  end
  
  it 'finds a title' do
    page = Page.get 'http://fredkelly.net'
    page.title.empty?.should be_false
  end
  
  it 'finds a meta description' do
    page = Page.get 'http://fredkelly.net'
    page.description.empty?.should be_false
  end
  
  it 'returns nil for unreachable hosts' do
    page = Page.get 'http://foo.bar'
    page.nil?.should be_true
  end
  
  it 'ignores bad hosts' do
    page = Page.get 'http://www.facebook.com/groups/361475813912538/'
    page.nil?.should be_true
  end
  
end