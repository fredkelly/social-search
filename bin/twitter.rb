module Twitter
  # Overrides to allow > 100 results,
  # as well as storing/loading from file.
  def self.search(q, options = {})
    results = []
    results_file = "./stored/#{options[:file]}.tweets"
    
    begin
      # try reading from stored
      results = Marshal.load File.read(results_file)
    rescue
      # get results from twitter
      options[:rpp] ||= 100
      for page in 1..(options[:rpp]/100)
        results += super(q, options.merge(:page => page, :rpp => 100)).results
      end
    end
    
    # save to file?
    unless options[:file].nil?
      File.open(results_file, 'w') do |file|
        file.write Marshal.dump(results)
      end
    end
    
    # return Tweets
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