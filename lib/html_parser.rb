# Based on https://github.com/jnunemaker/httparty/blob/master/examples/nokogiri_html_parser.rb
class HtmlParser < HTTParty::Parser
  SupportedFormats.merge!('text/html' => :html)

  def html
    Nokogiri::HTML(body)
  end
end