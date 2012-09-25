module Twitter
  def self.search(q, options = {})
    results = []
    options[:rpp] ||= 100
    for page in 1..(options[:rpp]/100)
      results += super(q, options.merge(:page => page, :rpp => 100)).results
    end
    results
  end
  
  class Tweet
    alias_method :to_s, :text
    
    # WIP
    # chunks text into tokens
    def tokens
      @tokens ||= text.split
    end
  end
end