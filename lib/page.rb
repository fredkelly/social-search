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
    response = super(url)
    self.new(response.parsed_response, nil) if response.success?
  end
    
  def description
    meta_description || body_text
  end
  
  def meta_description
    document.xpath("//meta[@name=\"description\"]/@content").inner_text
  end
  
  include ActionView::Helpers::TextHelper
  def body_text
    truncate(document.at(:body).inner_text.gsub(/[\s]+/, ' '), separator: '.', length: 255)
  end
end