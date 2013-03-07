module Clustering
  # extends Tweet class to add clustering specific operations
  class Document < Twitter::Tweet
    
    # splits tweet text into tokens
    def tokens
      tokeniser = Tokeniser.new(lang: iso_language_code)
      @tokens ||= tokeniser.tokenise(text)
    end
    
  end
end