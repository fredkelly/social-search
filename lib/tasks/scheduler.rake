desc "This task keeps the Heroku dyno running"
task :call_page => :environment do
  uri = URI.parse('http://social-search.herokuapp.com/')
  Net::HTTP.get(uri)
end

desc "This task generates the application statistics"
task :generate_aggregate => :environment do
  StatisticsAggregate.create
end
