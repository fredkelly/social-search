class SearchController < ApplicationController
  respond_to :html, :json
  
  def index
    @recents = Search.recents
  end
  caches_action :index, expires_in: 30.minutes
  
  # Creates a new search belonging to the current session.
  # redirect to results page?
  def create
    @search = current_session.searches.where(query: params[:query]).first_or_create
    
    if @search.empty?
      documents = Twitter.search(params[:query], count: 100, lang: :en, include_entities: true).statuses
      clusterer = Clustering::HAC.new(documents, measure: :intersection_size)
    
      # create results from the clusters
      clusterer.cluster!.sort.each_with_index do |cluster, position|
        logger.info cluster.size
        next if cluster.url.nil? or cluster.size < 5
        @search.results.create!(
          source_engine: 'Clustering::HAC', url: cluster.url, position: position
        )
      end
    end
    
    respond_with @search, template: 'search/results'
  end
  
  # add feedback (to be AJAX'd)
  def comment
    @search  = current_session.searches.find(params[:search_id])
    @comment = @search.comments.create!(params.slice(:rating, :comment))
    
    respond_with @comment
  end
end
