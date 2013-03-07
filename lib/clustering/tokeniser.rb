module Clustering
  class Tokeniser
    def initialize(options)
      @lang = options[:lang]
    end
    
    def tokenise(passage)
      passage.downcase.split
    end
    
    def tokenise!(passage)
      passage = tokenise(passage)
    end
  end
end