class SocialSearch < Sinatra::Base
  get '/' do
    erb :search
  end
  
  get '/manual' do
    @samples = Twitter.load(params[:file])
    erb :manual
  end
  
  post '/manual' do
    samples = Twitter.load(params[:file])
    labels = Hash[*params[:labels].to_a.flatten.map(&:to_i)]
    @clusterer = ManualClusterer.new(samples, labels)
    erb :results
  end
end