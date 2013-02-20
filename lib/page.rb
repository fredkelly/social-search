require 'timeout'

class Page
  include HTTParty
  parser HtmlParser
  
  attr_reader :document, :url
  
  delegate :title, to: :document
  
  # get timeout (secs)
  TIMEOUT = 10
  
  # ignored hosts
  IGNORED_HOSTS = %w(facebook.com fb.me spotify.com spoti.fi)
  
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
    rescue Exception => error # HTTParty::RedirectionTooDeep or Timeout::Error
      Rails.logger.info "Gave up scraping page (#{error})."
      return nil
    end
    # ignore short urls
    return nil if response.request.last_uri.host.size < 10 || IGNORED_HOSTS.include?(response.request.last_uri.host.gsub('www.',''))
    # genearte instance using Nokogiri::Document & resolved URL
    self.new(response.parsed_response, response.request.last_uri.to_s) # if response.success?
  end
    
  def description
    (meta_description unless meta_description.empty? || generic_meta_description?) || body_text
  end
  
  def meta_description
    @meta_description ||= document.xpath("//meta[@name=\"description\"]/@content").inner_text
  end
  
  # checks for generic description
  # i.e. if there are common words in the first
  # 30 characters of the <title> and <meta> description.
  def generic_meta_description?
    [truncate(document.title, length: 30, omission: ''), meta_description].map{|d| d.downcase.split}.reduce(&:&).size > 0
  end
  
  include ActionView::Helpers::TextHelper
  def body_text
    # needs more work, remove symbols etc.
    @body_text ||= document.search("//p[not(ancestor::noscript)]").map do |p|
      next if p.inner_text.size < 100
      p.inner_text.gsub(/[\s|<\/?.*>\s]+/, ' ').gsub(/[^0-9A-Za-z\s]/, '').strip
    end.compact.join(' ')[0..500] # limit to 500 chars
  end
end