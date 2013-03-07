class SearchController < ApplicationController  
  # GET
  def new
  end
  
  # GET /searches/?query=X
  def show
    @tweets = Twitter.search(params[:query]).statuses
  end
end
