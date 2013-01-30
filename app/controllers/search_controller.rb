class SearchController < ApplicationController
  def index
  end
  
  # Creates a new search belonging to the current session.
  # redirect to results page?
  def create
    # TODO: limit based on created_at
    @search = current_session.searches.first_or_create(query: params[:query])
    
    render :results
  end
end
