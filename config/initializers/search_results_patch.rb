# monkey patch to return custom document instances
module Twitter
  class SearchResults
    def statuses
      @results ||= Array(@attrs[:statuses]).map do |tweet|
        Clustering::Document.fetch_or_new(tweet)
      end
    end
  end
end