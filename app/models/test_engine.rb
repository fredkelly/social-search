class TestEngine < Engine
  SCRAPED = true
  SEARCH_OPTS = {
    rpp: 100,
    lang: :en,
    result_type: :mixed
  }
  
  def initialize(search)
    @samples = search(self.class.expand_query(search.query)).results
    # must rebuild this into it's own class (and get rid of gem!)
    @clusters = Clusterer::Clustering.cluster(:hierarchical, @samples, no_stem: true, tokenizer: :simple_ngram_tokenizer) {|t| t.text}
    
    @clusters.sort.each_with_index do |cluster, position|
      unless cluster.url.nil?        
        begin          
          result = search.results.create(
            # generate description from tweet text?
            source_engine: self.class, url: cluster.url, position: position
          )
          raise result.errors.full_messages.join(',') if !result
          # print cluster & samples
          Rails.logger.info "Cluster #{position}..\n\t" + cluster.objects.join("\n\t")
        rescue StandardError => error
          position -= 1 # skip count
          Rails.logger.info "Skipped a cluster!.. #{error}."
        end
      end
    end
  end
  
  def search(query)
    # searches for tweets containing links (excl. retweets)
    @search ||= Twitter.search("#{URI::escape(query)} filter:links +exclude:retweets", SEARCH_OPTS)
  end
  
  # WIP
  def self.expand_query(query)
    query.split.map{|t| "#{t} ##{t} #{t.stem}"}.join(' ')
  end
end

class Twitter::Tweet
  alias_method :to_s, :text
  
  def expanded_urls
    urls.map(&:expanded_url)
  end
  
  def images
    entities.media.map(&:media_url)
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
  
  # add images method! can get from entities excl. instagram
end

Enumerable.class_eval do
  def mode
    group_by{|e| e}.values.max_by(&:size).first
  end
end