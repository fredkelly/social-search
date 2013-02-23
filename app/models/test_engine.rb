class TestEngine < Engine
  SCRAPED = true
  SEARCH_OPTS = {
    rpp: 100,
    lang: :en,
    result_type: :mixed
  }
  
  def initialize(search)
    @samples = search(expanded = self.class.expand_query(search.query)).results
    
    # debug for live demo
    CustomLogger.info "New search for \"#{search.query}\", expanded to \"#{expanded}\", found #{@samples.size} tweets.".red.on_black
    
    # must rebuild this into it's own class (and get rid of gem!)
    @clusters = Clusterer::Clustering.cluster(:hierarchical, @samples,
                                                no_stem: true,
                                                tokenizer: :simple_ngram_tokenizer
                                              ) {|t| t.text}
    
    @clusters.sort.each_with_index do |cluster, position|
      unless cluster.url.nil?        
        begin
          # throws an error if validation fails
          result = search.results.create!(
            # generate description from tweet text?
            source_engine: self.class, url: cluster.url, position: position
          )
          # print cluster & samples
          CustomLogger.info "\nCluster #{position}..\n\t".red + cluster.objects.join("\n\t") + "\n..scraping \"#{result.url}\"..".magenta + "\n"
        rescue ActiveRecord::RecordNotSaved => error
          CustomLogger.info "Skipped a cluster (failed validation: #{error})..\n".red
          position = position - 1 # skip count
        end
      end
    end
  end
  
  def search(query)
    # searches for tweets containing links (excl. retweets)
    @search ||= Twitter.search("#{URI::escape(query)} filter:links +exclude:retweets", SEARCH_OPTS)
  end
  
  # WIP
  def self.expand_query(query, concat_length = 2)
    terms = query.split.permutation(concat_length).map(&:join) << query
    (terms.map{|t| [t, '#' + t] + (t.stem != t ? [t.stem, '#' + t.stem] : [])}.flatten).join(' OR ')
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