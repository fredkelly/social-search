module SearchHelper
  def truncate_url(url, options = { length: 30 })
    return url if url.length <= options[:length]
    uri = URI.parse(url)
    chunk = [uri.path, uri.query].compact.sort_by(&:size).last # take the bigger part
    url.gsub(chunk, truncate(chunk, length: options[:length] - url.length, separator: '/', omission: '.../'))
  end
end
