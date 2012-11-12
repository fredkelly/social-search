class Page
  include HTTParty
  parser HtmlParserIncluded
  
  def self.get(url)
    parse_response(super(url), url)
  end
  
  # Parses the <tt>Nokogiri::HTML::Document</tt> instance
  # into a <tt>Result</tt> instance.
  #
  # Move parsing login into <tt>Result</tt>? e.g.
  # create a Result.initialize which accepts a <tt>Nokogiri::HTML::Document</tt> instance?
  #
  # @param [Nokogiri::HTML::Document] document The response object.
  # @param [String] url The scraped document's URL.
  #
  def self.parse_response(document, url)
    Result.new(document.title, url, parse_description(document))
  end
  
  # Quick helper to get a useful description.
  # Needs to be refactored, probably moved to <tt>Result</tt>. 
  #
  # @param [Nokogiri::HTML::Document] document The response object.
  #
  def self.parse_description(document)
    # WIP, this is very ugly but gets the job done!
    # take either the <meta> description or first paragraph..
    document.css('meta[name=\'description\']').first['content'] rescue document.xpath('//p//a/text()').inner_text.chomp
  end
end