class TestEngine < Engine
  SCRAPED = true
  SEARCH_OPTS = {
    rpp: 100,
    lang: :en,
    result_type: :mixed,
    include_entities: true
  }
  
  def initialize(search)    
    begin
      @samples = search(expanded = self.class.expand_query(search.query)).results
    rescue Twitter::Error => error
      raise $!, "Unable to retrieve Tweets: #{$!}", $!.backtrace
      return # stop here..
    end
    
    # debug for live demo
    CustomLogger.info "\n[#{Time.now}] New search for \"#{search.query}\", expanded to \"#{expanded}\", found #{@samples.size} tweets.".red.on_black
    
    # must rebuild this into it's own class (and get rid of gem!)
    @clusters = Clusterer::Clustering.cluster(:hierarchical, @samples,
                                                no_stem: false,
                                                tokenizer: :simple_ngram_tokenizer
                                              ) {|t| t.text}
    
    result = nil
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
          CustomLogger.info "\nImage URLs:\n" + cluster.image_urls.join("\n\t")
        rescue StandardError => error
          CustomLogger.info "Skipped a cluster (#{error})..\n\n".red
          CustomLogger.info "ActiveRecord said:" + result.errors.full_messages.join("\n\t") if error.is_a?(ActiveRecord::RecordNotSaved)
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
    (terms.map{|t| [t, '#' + t, '@' + t] + (t.stem != t ? [t.stem, '#' + t.stem, '@' + t.stem] : [])}.flatten).join(' OR ')
  end
end

class Twitter::Tweet
  alias_method :to_s, :text
  
  def expanded_urls
    urls.map(&:expanded_url)
  end
  
  def image_urls
    media.map(&:media_url)
  end
  
  def instagrams
    # WIP
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
  
  def image_urls
    objects.map(&:media).flatten.uniq
  end
  
  # add images method! can get from entities excl. instagram
end