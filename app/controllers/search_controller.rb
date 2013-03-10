require 'benchmark'

class SearchController < ApplicationController  
  # GET
  def new
  end
  
  # GET /searches/?query=X
  def show
    documents, clusterer = nil
    
    Benchmark.bm(12) do |x|
      x.report("Twitter:") do
        documents = Twitter.search(params[:query], count: 100, lang: :en, include_entities: true).statuses
      end
      
      x.report("Clustering") do
        # do the clustering
        clusterer = Clustering::HAC.new(documents, measure: :intersection_size)
        clusterer.cluster!
      end
    end
        
    @clusters = clusterer.clusters
  end
end
