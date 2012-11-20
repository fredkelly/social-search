# A result, be it from Google or a clustering.
# results are the instances that are displayed to
# the user when they complete a search.
class Result < Struct.new(:title, :url, :description)
  # truncated description
  def excerpt
    description.split[0..50].join(' ') + '...'
  end
end