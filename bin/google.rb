# Super basic wrapper for the Google search
# API[https://developers.google.com/web-search/] (v1.0)
#
# The API is still currently accessible despite being deprecated.
#
class Google
  
  include HTTParty
  
  format :json
  base_uri "http://ajax.googleapis.com/ajax/services/"
  default_params :v => 1.0
  
  # Search method returns a <tt>HTTParty::Response</tt>
  # instance for a given search term.
  #
  # @param [String] q The search term.
  #
  def self.search(q)
    get('/search/web', query: { :q => q })
  end
  
end