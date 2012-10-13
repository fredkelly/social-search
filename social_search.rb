class SocialSearch < Sinatra::Base
  get '/' do
    erb :search
  end
  
  get '/search' do
    samples = Twitter.search(params[:q], rpp: 1000)
    @clusterer = Clusterer.new(samples)
    #@clusterer.cluster!
    
    erb :results
  end
  
  get '/manual' do
    if File.exists?(params[:stash])
      @clusterer = Clusterer.load(params[:stash])
    else
      samples = Twitter.search(params[:q], rpp: 100)
      @clusterer = ManualClusterer.new(samples, params[:k].to_i)
    end
    @clusterer.save(params[:stash])
    
    erb :manual
  end
  
  post '/manual' do
    labels = Hash[*params[:labels].to_a.flatten.map(&:to_i)]
    @clusterer = ManualClusterer.load(params[:stash])
    @clusterer.cluster!(labels)
    
    @clusterer.save
    
    erb :results
  end
end