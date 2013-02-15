class TestEngine < Engine
  SCRAPED = true
  SEARCH_OPTS = {
    rpp: 100,
    lang: :en,
    result_type: :mixed
  }
  
  def initialize(search)
    @samples = search(search.query).results    
    @clusters = Clusterer::Clustering.cluster(:hierarchical, @samples, no_stem: true, tokenizer: :simple_ngram_tokenizer) {|t| t.text}
    
    @clusters.sort.each_with_index do |cluster, position|
      unless cluster.url.nil?
        begin
          search.results.create(
            source_engine: self.class, url: cluster.url, position: position
          )
        rescue Exception => error
          Rails.logger.info "Skipped a cluster!.. #{error}."
          position -= 1 # skip count
        end
      end
    end
  end
  
  def search(query)
    # searches for tweets containing links (excl. retweets)
    @search ||= Twitter.search("#{URI::escape(query)} filter:links +exclude:retweets", SEARCH_OPTS)
  end
end

class Twitter::Tweet
  def expanded_urls
    urls.map(&:expanded_url)
  end
end

class Clusterer::Cluster
  def <=>(other)
    # inverted so biggest is first
    other.objects.size <=> objects.size
  end
  
  def objects
    @documents.map(&:object)
  end
  
  def url
    objects.map(&:expanded_urls).flatten.mode # take most frequent
  end
end

Enumerable.class_eval do
  def mode
    group_by{|e| e}.values.max_by(&:size).first
  end
end