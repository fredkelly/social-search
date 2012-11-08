# A result, be it from Google or a clustering.
# results are the instances that are displayed to
# the user when they complete a search.
class Result < Struct.new(:title, :url, :description)
  # truncate descriptions
  def description
    super.split[0..50].join(' ') + '...'
  end
end