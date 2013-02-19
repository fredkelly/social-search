ActiveAdmin.register Session do
  index do
    column 'ID' do |session|
      link_to session.id, admin_session_path(session)
    end
    column 'Key' do |session|
      truncate(session.session_id, length: 10)
    end
    column 'IP', :remote_ip
    column 'Platform' do |session|
      "#{session.user_agent.name} (#{session.user_agent.os})"
    end
    column 'Created', :created_at
    column 'App Updated', :app_version
    column 'Searches #' do |session|
      session.searches.size # needs count-caching (link?)
    end
    column :accept_language
    column :accept_charset
  end
  
  show do
    # hacky!
    panel 'User Agent' do
      div class: 'attributes_table' do
        table do
          tr do
            th 'Name'
            td session.user_agent.name
          end
          tr do
            th 'Version'
            td session.user_agent.version
          end
          tr do
            th 'OS'
            td session.user_agent.os
          end
        end
      end
    end
    
    panel 'Searches' do
      table_for session.searches do
        column :id
        column :query
        column 'Created', :created_at
        column 'Results #' do |search|
          search.results.size # needs count-caching (link?)
        end
        column 'Success?' do |search|
          search.success?
        end
      end
    end
    
    attributes_table do
      row :id
      row :session_id
      row :remote_ip
      row :accept_language
      row :accept_charset
      row :accept
      row :created_at
      row :app_version do |session|
        [session.app_version, ('(latest)' if session.app_version_latest?)].join(' ')
      end
      row :referer
      row :duration do |session|
        "%0.2f secs" % session.duration
      end
      row 'Searches #' do |searches|
        session.searches.size
      end
    end
  end
end
