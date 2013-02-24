class SearchController < ApplicationController
  def index
    @recents = Search.recents
  end
  caches_action :index, expires_in: 30.minutes
  
  # Creates a new search belonging to the current session.
  # redirect to results page?
  def create
    # TODO: limit based on created_at
    begin
      @search = current_session.searches.where(query: params[:query]).first_or_create
    rescue StandardError => error
      flash.now[:error] = "Sorry, an error occurred." + (Rails.env.production? ? "" : " (#{error})")
    end

    respond_to do |format|
      format.html { render :results }
      format.json { render json: { query: @search.query, size: @search.results.size, results: @search.results } }
    end
  end
  
  # add feedback (to be AJAX'd)
  def comment
    @comment = current_session.searches.find(params[:search_id]).comments.create!(params.slice(:rating, :comment))
    
    respond_to do |format|
      format.json { render json: @comment.valid? ? @comment : { errors: @comment.errors.full_messages } }
    end
  end
end
