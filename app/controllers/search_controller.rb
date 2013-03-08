class SearchController < ApplicationController  
  # GET
  def new
  end
  
  # GET /searches/?query=X
  def show
    # array of tweets
    documents = Twitter.search(params[:query], count: 100, lang: :en).statuses
    
    # do the clustering
    clusterer = Clustering::HAC.new(documents, measure: :normalised_levenshtein)
    @clusters = clusterer.cluster!
  end
end
