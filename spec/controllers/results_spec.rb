require 'spec_helper'

describe ResultsController do
  fixtures :results, :sessions

  before(:each) do
    ApplicationController.any_instance.stub(:current_session).and_return(@session = sessions(:dave))
  end

  describe 'GET #show' do
    it 'responds with HTTP 301 status' do
      get :show, id: results(:google).id
      expect(response.code.to_i).to eq(301)
    end
    
    it 'redirects to search url' do
      get :show, id: results(:google).id
      response.should redirect_to(results(:google).url)
    end
  end
end