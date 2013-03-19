class SearchController < ApplicationController
  respond_to :html, :json
  
  def index
    @recents = Search.recents
  end
  caches_action :index, expires_in: 30.minutes
  
  # for autocomplete
  def recents
    @recents = Search.recents(100)
    
    render json: @recents.map(&:query)
  end
  
  # Creates a new search belonging to the current session.
  # redirect to results page?
  def create
    begin
      @search = current_session.searches.where(query: params[:query]).first_or_create
    rescue Twitter::Error => error
      raise $!, "Unable to retrieve Tweets: #{$!}", $!.backtrace
    end
    
    if @search.empty?
      documents = Twitter.search(params[:query], count: 100, lang: :en, include_entities: true).statuses
      clusterer = Clustering::HAC.new(documents, measure: :intersection_size)
    
      # create results from the clusters
      clusterer.cluster!.sort.each_with_index do |cluster, position|
        begin
          @search.results.create!(
            source_engine: clusterer.class, url: cluster.url,
            position: position, media_urls: cluster.media_urls,
            time_delta: cluster.time_delta
          )
        rescue Exception => e
          logger.info e
          next # skip if fails validations
        end
      end
    end
    
    respond_with @search, template: 'search/results'
  end
  
  # add feedback (to be AJAX'd)
  def comment
    @search  = current_session.searches.find(params[:search_id])
    @comment = @search.comments.create!(params.slice(:rating, :comment))
    
    render json: @comment
  end
  
  def modals
    @search = Search.find(params[:search_id]) if params[:search_id]
    render template: "modals/#{params[:modal_id]}", layout: nil, search: @search
  end
end
