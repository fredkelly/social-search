class Page
  include HTTParty
  parser HtmlParserIncluded
end

class Nokogiri::HTML::Document
  def description
    # meta description, or document text
    (css('meta[name=\'description\']').first['content'] rescue at('body').inner_text).chomp
  end
end