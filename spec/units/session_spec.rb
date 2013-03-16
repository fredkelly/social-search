require 'spec_helper'

describe Session do
  fixtures :sessions
  
  it 'validates presence of session_id' do
    session = Session.new(session_id: nil)
    session.valid?.should be_false
  end
  
  it 'should parse user_agent' do
    expect(sessions(:dave).user_agent.os.to_s).to eq('Mac OS X 10.8.2')
  end
  
  it 'should calculate duration' do
    # based on data given in fixture
    expect(sessions(:dave).duration).to eq(1.hour)
  end
end