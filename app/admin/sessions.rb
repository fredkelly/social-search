ActiveAdmin.register Session do
  index do
    column 'ID', :id
    column 'IP', :remote_addr
    column 'Platform' do |session|
      "#{session.user_agent.browser} (#{session.user_agent.platform})"
    end
    column 'Created', :created_at
    column 'App Updated', :app_version
    column 'Searches #' do |session|
      session.searches.size # needs count-caching (link?)
    end
    column :accept_language
    column :accept_charset
  end
end
