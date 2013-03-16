require 'spec_helper'

describe SearchController do
  fixtures :searches, :sessions
  
  before(:each) do
    ApplicationController.any_instance.stub(:current_session).and_return(@session = sessions(:dave))
  end
  
  describe 'GET #index' do
    it 'responds with HTTP 200 status' do
      get :index
      expect(response).to be_success
      expect(response.code.to_i).to eq(200)
    end
    
    it 'renders the index view' do
      get :index
      expect(response).to render_template('index')
    end
  end
  
  describe 'GET #search' do
    it 'creates a new search' do
      get :create, query: query = 'manchester'
      expect(response).to be_success
      expect(@session.searches.first.query).to eq(query)
    end
  end
end