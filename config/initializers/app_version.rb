module SocialSearch
  class Application
    # using custom buildback from Heroku (if prod)
    FILE_VERSION ||= File.new(Rails.root.join('Gemfile.lock')).mtime
  end
end