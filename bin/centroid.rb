# Utility class encapsulates generated
# Centroids, providing the same methods
# as <tt>Twitter::Tweet</tt> instances.
class Centroid
  attr_reader :tokens
  
  # Sets up a new Centroid using given token array.
  #
  # @param [Array] tokens The centroid's token string.
  #
  def initialize(tokens)
    @tokens = tokens
  end
  
  # Merges token array into string.
  def text
    @text ||= tokens.join(' ')
  end
  alias_method :to_s, :text
  
  # WIP; Returns URL's contained in centroid
  def urls
    []
  end

end