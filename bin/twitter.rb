require 'stopwords'

module Twitter
  
  # Max items per request as specified by Twitter's API.
  MAX_RPP = 100
  
  # Default parameters to be passed
  # with each request to the Twitter API.
  DEFAULT_OPTS = {
    :rpp => MAX_RPP,
    :lang => :en,
    :result_type => :recent,
    :include_entities => true
  }
  
  # Overrides superclass method to allow options[:rpp] > 100.
  # Splits search into chunks of 100 messages and loops
  # through populating a single +results+ array.
  #
  # @param [String] q Query string.
  #
  # @option options [Fixnum] rpp Number of results, defaults to 100.
  # @option options [Symbol] lang Tweet language, defaults to english.
  # @option options [Symbol] result_type Whether to get +recent+, +popular+ or +mixed+ results, defaults to +recent+.
  # @option options [Boolean] include_entities Whether to attach entity objects (e.g. urls, images etc.), defulats to +true+.
  #
  def self.search(q, options = {})
    results = []
    
    # add default options
    options = DEFAULT_OPTS.merge(options)
    
    # pull results from twitter
    for page in 1..(options[:rpp]/MAX_RPP).ceil
      results += super(q, options.merge(:page => page, :rpp => MAX_RPP)).results
    end

    results
  end

  # Adds some additional methods to the
  # superclass for quickly parsing out
  # useful features such as urls, or tokens.
  class Tweet
    # represent Tweets by their text
    alias_method :to_s, :text
    
    # use unique id as hash value ensures
    # <tt>Set</tt> only contains uniqe entries.
    alias_method :hash, :id
    
    # Splits a Tweet's text into an array
    # of lowercase word tokens and removes stop words.
    #
    # e.g. for using a Bag-of-words[http://en.wikipedia.org/wiki/Bag-of-words_model] model.
    #
    def tokens
      @tokens ||= text.downcase.split - Stopwords::STOP_WORDS
    end
    
    # Returns true of the Tweet contains a URL.
    def has_url?
      !urls.empty?
    end
    
    # Returns an array of the URLs in the Tweet.
    #
    # If the Tweet contains only a single link
    # then the singleton [url] will be returned.
    #
    def urls
      attrs[:entities][:urls].map do |url|
        url[:expanded_url] || url[:url]
      end
    end
  end
  
end