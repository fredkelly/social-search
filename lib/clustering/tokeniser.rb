module Clustering
  class Tokeniser
    
    # initializes with options hash
    def initialize(options = {})
      @lang = options[:lang] || :en
    end
    
    # perfoms the tokenisation
    def tokenise(passage)
      passage.downcase.split
    end
    
    # destructive tokeniser
    def tokenise!(passage)
      passage = tokenise(passage)
    end
    
  end
end