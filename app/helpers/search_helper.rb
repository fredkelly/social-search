module SearchHelper
  def truncate_url(url, options = { length: 30 })
    return url if url.length <= options[:length]
    path = URI.parse(url).path # we just shorten the path for now
    url.gsub(path, truncate(path, length: path.length - options[:length], separator: '-', omission: '.../'))
  end
end
