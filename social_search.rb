class SocialSearch < Sinatra::Base
  
  get '/' do
    erb :search
  end
  
  get '/search' do
     # get new samples from twitter, and create clusterer
    samples = Twitter.search(params[:q], rpp: 1000)
    @clusterer = Clusterer.new(samples)
    
    # perform clustering
    #@clusterer.cluster!
    
    erb :results
  end
  
  get '/manual' do
    if File.exists?(params[:stash])
      # reload the saved cluster obj
      @clusterer = Clusterer.load(params[:stash])
    else
      # get new samples from twitter, and create clusterer
      samples = Twitter.search(params[:q], rpp: 1000)
      @clusterer = ManualClusterer.new(samples, params[:k].to_i)
    end
    
    # save back to specified path
    @clusterer.save(params[:stash])
    
    if @clusterer.samples.empty?
      erb :results
    else
      erb :manual
    end
  end
  
  post '/manual' do
    # mash into hash, sample.id -> cluster no.
    labels = Hash[*params[:labels].to_a.flatten.map(&:to_i)]
    
    # reload the saved cluster obj
    @clusterer = ManualClusterer.load(params[:stash])
    
    # perform clustering using labels
    @clusterer.cluster!(labels)
    
    # save to file
    @clusterer.save
    
    erb :results
  end
  
end