class SocialSearch < Sinatra::Base
  
  get '/' do
    erb :search
  end
  
  get '/search' do
     # get new samples from twitter, and create clusterer
    samples = Twitter.search(params[:q], rpp: 1000)
    @clusterer = KMeans.new(samples)
    
    # perform clustering
    @clusterer.cluster!
    
    erb :results
  end
  
  get '/manual' do
    # if we can't load the existing clusters..
    unless @clusterer = ManualClusterer.load(params[:stash])
      # get new samples from twitter, and create clusters
      samples = Twitter.search(params[:q], rpp: 1000)
      @clusterer = ManualClusterer.new(samples, params[:k].to_i - 1)
    end
    
    # save back to specified path
    @clusterer.save(params[:stash]) if params[:stash]
    
    # have we finished classifying?
    erb @clusterer.samples.empty? ? :results : :manual
  end
  
  post '/manual' do        
    # reload the saved cluster obj
    @clusterer = ManualClusterer.load(params[:stash])
    
    # perform clustering using labels
    @clusterer.cluster!(to_ints(params[:labels]))
    
    # save to file
    @clusterer.save
    
    erb :results
  end
  
  private
  
  # convert key/values to integers
  def to_ints(hash)
    Hash[*hash.to_a.flatten.map(&:to_i)]
  end
  
end