class Page
  include HTTParty
  parser HtmlParserIncluded
  
  def self.get(url)
    parse_response(super(url), url)
  end
  
  # Parses the <tt>Nokogiri::HTML::Document</tt> instance
  # into a <tt>Result</tt> instance.
  #
  # @param [HTTParty::Response] response The response object.
  #
  def self.parse_response(document, url)
    Result.new(document.title, url, (document.css('meta[name=\'description\']').first['content'] rescue ''))
  end
  
end