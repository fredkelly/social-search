#!/usr/bin/env ruby

require 'bundler'
require 'benchmark'
Bundler.require(:default, :test)

# require all files in ./bin
Dir[File.dirname(__FILE__) + '/bin/*.rb'].each {|file| require file }

# get source classification
while !File.exists?(stash_file ||= '')
  stash_file = ask('Enter path to stashed Clusterer (.stash)..')
end

# load stashed clusteerer
standard = Clusterer.load(stash_file)
samples = standard.clustered_samples.clone

puts "Loaded #{standard.class} instance with #{samples.size} clustered samples.."

# select classifier to test
candidate = nil
choose do |menu|
  menu.choices(*Clusterer.descendants) {|klass| candidate = klass}
  menu.prompt = "Select Clusterer candidate from above.."
end

# init the candidate with verbose ON..
clustering = candidate.new(samples, standard.options.merge(:verbose => true))

# perform clustering!
clustering.cluster!

puts standard.compare_to(clustering)