# A result, be it from Google or a clustering.
# results are the instances that are displayed to
# the user when they complete a search.
class Result < Struct.new(:title, :url, :description)
  # truncate descriptions
  def description
    super.split[0..50].join(' ') + '...'
  end
  
  # crude approximation as to if the
  # cluster/result is worth displaying
  # i.e. does it have a url, title & description?
  def is_valid?
    !!page
  end
  
  private
  
  def page
    @page ||= (Page.get(url) rescue nil) unless url.nil?
  end
end