class SearchController < ApplicationController  
  # GET
  def new
  end
  
  # GET /searches/?query=X
  def show
    # array of tweets
    documents = Twitter.search(params[:query], count: 100, lang: :en).statuses
    
    # do the clustering
    clusterer = Clustering::MajorClust.new(documents)
    @clusters = clusterer.cluster!
  end
end
