module SocialSearch
  class Application
    # using custom buildback from Heroku (if prod)
    VERSION ||= Rails.env.production? ? ENV['SHA'] : %x(git rev-parse HEAD).chomp
  end
end