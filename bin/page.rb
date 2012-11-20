# Represents a web page scraped based on a URL
# uses the HTTParty & Nokogiri to get & parse.
class Page
  include HTTParty
  parser HtmlParserIncluded
end

# Adds description method to <tt>Nokogiri::HTML::Document</tt>. 
class Nokogiri::HTML::Document
  # gets the descripton of the HTML document
  # trys to read from <meta name="description"/> first;
  # if empty, it uses the document's inner_text property.
  def description
    # meta description, or document text
    (css('meta[name=\'description\']').first['content'] rescue at('body').inner_text).chomp
  end
end