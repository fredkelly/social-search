class SearchController < ApplicationController
  def index
  end
  
  # Creates a new search belonging to the current session.
  # redirect to results page?
  def create
    # TODO: limit based on created_at
    @search = current_session.searches.where(query: params[:query]).first_or_create
    
    render :results
  end
end
