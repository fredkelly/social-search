module Clustering
  class DistanceMeasure
    
    def initialize(measure)
      @measure = measure || :normalised_levenshtein
    end
    
    def distance(*args)
      args.map(&:class).each do |klass|
        raise '#{__method__}: given #{klass}, expected an Enumerable' unless klass.include?(Enumerable)
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
    
    # Longest Common Subsequence
    # http://bit.ly/15FEimV
    def self.lcs(a, b)
      return [] if a.empty? or b.empty?
      
      m = Array.new(a.size) { [0]*b.size }
      longest, end_pos = 0,0
      (0..a.size-1).each do |x|
        (0..b.size-1).each do |y|
          if a[x] == b[y]
            m[x][y] = 1
            if (x > 0 && y > 0)
              m[x][y] += m[x-1][y-1]
            end
            if m[x][y] > longest
              longest = m[x][y]
              end_pos = x
            end
          end
        end
      end
      return a[end_pos-longest+1..end_pos]
    end
    
    def self.normalised_lcs(a, b)
      1.0 - lcs(a, b).size.to_f / [a, b].map(&:size).max
    end
    
  end
end