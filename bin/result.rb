# A result, be it from Google or a clustering.
# results are the instances that are displayed to
# the user when they complete a search.
class Result < Struct.new(:title, :url, :description)
  # truncated description
  def excerpt(length = 50)
    if description.size > length
      description.split[0..length].join(' ') + '..'
    else
      description
    end
  end
end