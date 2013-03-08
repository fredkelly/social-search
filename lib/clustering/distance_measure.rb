module Clustering
  class DistanceMeasure
    
    def initialize(measure)
      @measure = measure || :normalised_levenshtein
    end
    
    def distance(*args)
      args.map(&:class).each do |klass|
        raise "#{__method__}: given #{klass}, expected Array" unless klass == Array
      end
      self.class.send(@measure, *args)
    end
        
    # based on http://en.wikipedia.org/wiki/Levenshtein_distance
    # pretty slow, faster C based implementations do exist.
    def self.levenshtein(a, b)
      #case
      #  when a.empty? then b.size.to_f
      #  when b.empty? then a.size.to_f
      #  else [(a[0] == b[0] ? 0.0 : 1.0) + levenshtein(a[1..-1], b[1..-1]),
      #        1.0 + levenshtein(a[1..-1], b),
      #        1.0 + levenshtein(a, b[1..-1])].min
      #end
      Levenshtein.distance(a, b)
    end
    
    def self.normalised_levenshtein(a, b)
      #levenshtein(a, b) / [a, b].map(&:size).max
      Levenshtein.normalized_distance(a, b)
    end
    
    # computes ratio of intersection to union size
    def self.intersection_size(a, b)      
      return 0.0 if a.empty? or b.empty?
      1.0 - (a & b).size.to_f / (a | b).size
    end
    
  end
end