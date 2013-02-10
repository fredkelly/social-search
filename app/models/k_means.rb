class KMeans < Engine
  # tells result objects to generate
  # descriptions by scraping their url.
  SCRAPED = true
  
  def initialize(search, options = { k: 5, threshold: 0.90, iterations: 3 })
    @options  = options
    @samples  = Twitter.search(
                  "#{URI::escape(search.query)} filter:links +exclude:retweets", # only tweets with links + exclude retweets
                  rpp: 100, lang: :en, result_type: :mixed
                ).results.map{ |t| Sample.new(t) }
        
    @clusters = @samples.in_groups(@options[:k], false).reject{|g| g.empty?}.map{ |c| Cluster.new(c) }
        
    cluster!
    
    # WIP; clusters, sorted by size
    @clusters.sort_by(&:size).each_with_index do |cluster, position|
      
      Rails.logger.info "Cluster #{position+1}, size: #{cluster.size}..., centroid = #{cluster.centroid.tokens.join(',')}"
      cluster.samples.map{|s| Rails.logger.info "\t#{s.tokens.join(',')}"}
      
      unless cluster.no_url?
        begin
          url = cluster.url
          search.results.create(
            source_engine: self.class, url: url, position: position
          )
        rescue Exception => error
          Rails.logger.info "Skipped a cluster!.. #{error}."
          position -= 1 # skip count
        end
      end
    end
  end
  
  def cluster!
    for i in 0..@options[:iterations]-1
      Rails.logger.info "KMeans iteration #{i+1}.."
      
      max_delta = -Float::INFINITY
      # WIP - Awful time complexity, needs fixing!
      @clusters.each do |cluster|
        delta = cluster.centre!
              
        if delta > max_delta
          max_delta = delta
        end
        
        cluster.samples.each do |sample|
          # closest cluster to sample
          closest = @clusters.sort_by{|c| KMeans.distance(c.centroid, sample) }.first
          # if we need to move the sample
          if closest != cluster
            cluster.samples.delete(sample)  # remove from current cluster
            closest.samples.add(sample)     # add it to the new cluster
          end
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
      @tokens ||= (@tweet.text rescue @tweet).downcase.split.map{|s| s.gsub(/[^a-z ]/, '')}.reject{|s| s.empty?} - ::Stopwords::STOP_WORDS # strip hashes??
    end
    
    def urls
      @tweet.urls.map(&:expanded_url).reject{|url| url.include?('fb.me')} # remove facebook urls!
    end
  end
  
  class Cluster
    attr_accessor :centroid, :samples
        
    def initialize(samples)
      @samples  = Set.new(samples)
      @centroid = @samples.to_a.sample # random
    end
    
    def urls
      @urls ||= @samples.map(&:urls).flatten
    end
    
    def url
      @url ||= urls.group_by{|url| url}.values.max_by(&:size).first rescue nil
    end
    
    def no_url?
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
    
    def size
      @samples.size
    end
  end
end