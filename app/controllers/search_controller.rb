class SearchController < ApplicationController
  def index
  end
  
  # Creates a new search belonging to the current session.
  # redirect to results page?
  def create
    # TODO: limit based on created_at
    #begin
      @search = current_session.searches.where(query: params[:query]).first_or_create
      #rescue Exception => error
    #  flash.now[:error] = "Error occurred. (#{error})"
    #end
    
    render :results
  end
end
