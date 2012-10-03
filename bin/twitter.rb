module Twitter
  # Overrides to allow > 100 results,
  # as well as storing/loading from file.
  def self.search(q, options = {})
    results = []
    results_file = result_file_for(options[:file])
    
    # get results from twitter
    options[:rpp] ||= 100
    for page in 1..(options[:rpp]/100)
      results += super(q, options.merge(:page => page, :rpp => 100)).results
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
  
  # retrieve stored search
  def self.load(name)
    Marshal.load File.read(result_file_for(name))
  end
  
  def self.result_file_for(name)
    "./stored/#{name}.tweets"
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