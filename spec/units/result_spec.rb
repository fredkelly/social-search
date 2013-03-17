require 'spec_helper'

describe Result do
  fixtures :results, :searches
  
  it 'validates presence of url' do
    result = Result.create(title: 'Test Result')
    result.valid?.should be_false
  end

end