require 'bundler'
Bundler.require

# require all files in ./bin
Dir[File.dirname(__FILE__) + '/bin/*.rb'].each {|file| require file }

require './social_search.rb'
run SocialSearch