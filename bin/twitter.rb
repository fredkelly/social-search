module Twitter
  
  MAX_RPP = 100
  DEFAULT_OPTS = {
    :rpp => MAX_RPP,
    :lang => :en,
    :result_type => :recent,
    :include_entities => true
  }
  
  # Overrides to allow > 100 results,
  # as well as storing/loading from file.
  def self.search(q, options = {})
    results = []
    
    # add default opts
    options = DEFAULT_OPTS.merge(options)
    
    # pull results from twitter
    for page in 1..(options[:rpp]/MAX_RPP).ceil
      puts "Getting page #{page} from Twitter.."
      results += super(q, options.merge(:page => page, :rpp => MAX_RPP)).results
    end

    results
  end

  class Tweet
    alias_method :to_s, :text
    alias_method :hash, :id # needed?
    
    # WIP
    # chunks text into tokens
    def tokens
      @tokens ||= text.downcase.split
    end
    
    def has_url?
      !urls.empty?
    end
    
    def urls
      attrs[:entities][:urls].map do |url|
        url[:expanded_url] || url[:url]
      end
    end
  end
  
end