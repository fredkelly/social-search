require 'timeout'

class Page
  include HTTParty
  parser HtmlParser
  
  attr_reader :document, :url
  
  delegate :title, to: :document
  
  # get timeout (secs)
  TIMEOUT = 5
  
  # Accepts a <tt>Nokogiri::HTML::Document</tt> document source.
  def initialize(document, url)
    @document = document
    @url      = url
  end
  
  # WIP
  def self.get(url)
    response = nil
    begin
      Timeout::timeout(TIMEOUT) do
        response = super(url, no_follow: false) # HTTP request - follows redirects
      end
    rescue # HTTParty::RedirectionTooDeep or Timeout::Error
      return nil
    end
    # ignore short urls
    Rails.logger.info "URI host = #{response.request.last_uri.host}"
    return nil if response.request.last_uri.host.size < 10
    # genearte instance using Nokogiri::Document & resolved URL
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
    document.xpath("//p[not(ancestor::noscript)]").inner_text.gsub(/[\s]+/, ' ')[0..500] # limit to 500 chars
  end
end