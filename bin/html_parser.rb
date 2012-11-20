# HTTParty Nokogiri extension as in
# https://github.com/jnunemaker/httparty/blob/master/examples/nokogiri_html_parser.rb
# passes the <tt>request.body</tt> to the <tt>Nokogiri::HTML</tt> constructor
# before returning it to the callee.
class HtmlParserIncluded < HTTParty::Parser
  SupportedFormats.merge!('text/html' => :html)
  
  # Method name specified by the SupportedFormats hash
  # return the HTML parsed representation of the request.
  def html
    Nokogiri::HTML(body)
  end
end