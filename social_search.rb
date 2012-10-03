class SocialSearch < Sinatra::Base
  get '/' do
    @results = Twitter.search('kate middleton', :rpp => 1000, :result_type => :recent, :file => 'test')
    puts @results.size
    @results.join('<br />')
  end
  
  get '/manual' do
    @samples = Twitter.load(params[:file])
    erb :manual
  end
  
  post '/manual' do
    samples = Twitter.load(params[:file])
    labels = Hash[*params[:labels].to_a.flatten.map(&:to_i)]
    @classifier = ManualClassifier.new(samples, labels)
    erb :results
  end
end