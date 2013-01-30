class SearchController < ApplicationController
  def index
  end
  
  # Creates a new search belonging to the current session.
  # redirect to results page?
  def create
    @search = current_session.searches.create(query: params[:query])
    
    render :results
  end
end
