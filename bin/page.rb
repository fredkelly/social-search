class Page
  include HTTParty
  parser HtmlParserIncluded
end

class Nokogiri::HTML::Document
  def description
    # meta description, or first 100 words
    (css('meta[name=\'description\']').first['content'] rescue at('body').inner_text[0..100]).chomp
  end
end