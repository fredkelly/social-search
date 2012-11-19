require 'bundler'
Bundler.require

# require all files in ./bin
#Dir[File.dirname(__FILE__) + '/bin/*.rb'].each {|file| require file }

require './bin/twitter.rb'
require './bin/cluster.rb'
require './bin/centroid.rb'
require './bin/clusterer.rb'
require './bin/kmeans_clusterer.rb'
require './bin/manual_clusterer.rb'
require './bin/google.rb'
require './bin/result.rb'
require './bin/html_parser.rb'
require './bin/page.rb'

require './social_search.rb'
run SocialSearch