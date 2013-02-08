class Page
  include HTTParty
  parser HtmlParser
  
  attr_reader :document, :url
  
  delegate :title, to: :document
  
  # Accepts a <tt>Nokogiri::HTML::Document</tt> document source.
  def initialize(document, url)
    @document = document
    @url      = url
  end
  
  def self.get(url)
    response = super(url, no_follow: false) # HTTP request - follows redirects
    self.new(response.parsed_response, response.request.last_uri.to_s) # if response.success?
  end
    
  def description
    (meta_description unless meta_description.empty?) || body_text
  end
  
  def meta_description
    document.xpath("//meta[@name=\"description\"]/@content").inner_text
  end
  
  include ActionView::Helpers::TextHelper
  def body_text
    # truncate paragraphs to 255 chars splitting on sentence boundaries
    truncate(document.xpath("//p").inner_text.gsub(/[\s]+/, ' '), separator: '. ', length: 255)
  end
end