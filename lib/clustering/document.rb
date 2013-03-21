module Clustering
  # extends Tweet class to add clustering specific operations
  class Document < Twitter::Tweet
    
    alias_method :to_s, :text
    
    # splits tweet text into tokens
    def tokens
      return @tokens unless @tokens.nil?
      tokeniser = Tokeniser.new(lang: iso_language_code, remove_stopwords: true, stem: true)
      @tokens = tokeniser.tokenise(text)
    end
    
    def text
      super.force_encoding('UTF-8')
    end
    
    def hashtags
      super.map{|h| h.text.downcase}
    end
    
    def media_urls
      return [] if profane?
      media.map(&:media_url) + instagram_urls
    end
    
    def expanded_urls
      urls.map(&:expanded_url)
    end
    
    # parse out instagram links into media urls
    def instagram_urls(size = :l)
      expanded_urls.map do |url|
        begin
          host, id = url.match(/http:\/\/(instagr\.am|instagram.com)\/p\/(.*)\//).captures
          "http://instagr.am/p/#{id}/media?size=#{size}"
        rescue
          nil
        end
      end.to_a.compact
    end
    
    def profane?
      @profane ||= ProfanityFilter::Base.profane?(text)
    end
    
    def time_delta
      @time_delta = Time.now - created_at
    end
    
  end
end