class SocialSearch < Sinatra::Base
  get '/' do
    #results = Twitter.search('kate middleton', :rpp => 1000, :result_type => :recent, :file => 'test')
    results = Twitter.search('', :file => 'test')
    puts results.size
    results.join('<br />')
  end
end