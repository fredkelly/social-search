class SocialSearch < Sinatra::Base
  get '/' do
    results = Twitter.search('kate middleton', :rpp => 1000, :result_type => :recent)
    puts results.size
    results.join('<br />')
  end
end