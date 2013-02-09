class KMeans < Engine
  # tells result objects to generate
  # descriptions by scraping their url.
  SCRAPED = true
  
  def initialize(search, options = { k: 10, threshold: 0.90, iterations: 3 })
    @options  = options
    @samples  = Twitter.search(
                  "#{URI::escape(search.query)} filter:links +exclude:retweets", # only tweets with links + exclude retweets
                  rpp: 100, lang: :en, result_type: :mixed
                ).results.map{ |t| Sample.new(t) }
                
    # experiment
    m = @samples.size
    n = @samples.map(&:tokens).flatten.uniq.size
    t = 0
    
    @samples.each do |a|
      @samples.each do |b|
        Rails.logger.info((a.tokens & b.tokens).to_a.join(','))
        t += 1 if (a.tokens & b.tokens).size > 0
      end
    end
    
    k = (m*n)/(t/2)
    
    Rails.logger.info "K calculated at #{k}. (m = #{m}, n = #{n}, t = #{t})."
                
    @clusters = @samples.sample(k).map{ |c| Cluster.new(c) }
    
    
    Rails.logger.info "clusters.size = #{@clusters.size}"
    
    cluster!
    
    result = nil
    # WIP; clusters, sorted by distance to original query string
    @clusters.sort_by{|cluster| KMeans.distance(cluster.centroid, Sample.new(search.query))}.each_with_index do |cluster, position|
      unless cluster.no_page?
        begin
          Rails.logger.info "#{cluster.url}"
          result = search.results.build(
            source_engine: self.class, url: cluster.url, position: position
          )
          result.save
        rescue Exception => error
          Rails.logger.info "Skipped a cluster!.. #{error}."
          result.destroy
          position -= 1 # skip count
        end
      end
    end
  end
  
  def cluster!
    for i in 0..@options[:iterations]-1
      Rails.logger.info "KMeans iteration #{i+1}.."
      
      # for each sample
      @samples.each do |sample|
        # allocate to the cluster with closest centriod
        @clusters.sort_by{|cluster| KMeans.distance(cluster.centroid, sample) }.first.samples << sample
      end
    
      max_delta = -Float::INFINITY
      @clusters.each do |cluster|
        delta = cluster.centre!
      
        if delta > max_delta
          max_delta = delta
        end
      end
    
      Rails.logger.info "max_delta = #{max_delta}"
      break if max_delta > @options[:threshold]
    end
  end
  
  # a, b = <tt>KMeans::Sample</tt> instances
  # returns normalized distance based on number of common tokens
  # *NB* currently ignores repetition of tokens!
  def self.distance(a, b)
    1.0 - (a.tokens & b.tokens).size.to_f / (a.tokens + b.tokens).size
  end
  
  class Sample
    attr_accessor :tweet, :tokens
    
    def initialize(tweet)
      @tweet = tweet
    end
    
    def tokens
      @tokens ||= (@tweet.text rescue @tweet).downcase.split.map{|s| s.gsub(/[^a-z ]/, '')} - ::Stopwords::STOP_WORDS # strip hashes??
    end
    
    def urls
      @tweet.urls.map(&:expanded_url).reject{|url| url.include?('fb.me')} # remove facebook urls!
    end
  end
  
  class Cluster
    attr_accessor :centroid, :samples
    
    def initialize(centroid)
      @samples  = Set.new
      @centroid = centroid
    end
    
    def urls
      @urls ||= @samples.map(&:urls).flatten
    end
    
    def url
      @url ||= urls.group_by{|url| url}.values.max_by(&:size).first rescue nil
    end
    
    def no_page?
      url.nil?
    end
    
    def centre!
      # save old so we can calculate delta
      old = @centroid
      
      # for each token in cluster
      tokens = {}
      @samples.map{|s| s.tokens}.flatten.each do |token|
        tokens[token] = tokens[token].to_i + 1
      end
      
      # WIP, generate new string with specific word length etc.
      @centroid = Sample.new(tokens.sort_by{|k,v| v}[-[10, tokens.size].min..-1].map(&:first).join(' '))
      
      # return delta
      KMeans.distance(old, @centroid)
    end
  end
end