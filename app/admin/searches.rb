ActiveAdmin.register Search do
  index do
    column 'ID' do |search|
      link_to search.id, admin_search_path(search)
    end
    column :query
    column 'Created', :created_at
    column 'Updated', :updated_at
    column 'Results #' do |search|
      search.results.size # needs count-caching (link?)
    end
    column 'Success?' do |search|
      search.success?
    end
  end
  
  show do
    unless search.results.empty?
      panel 'Results' do
        table_for search.results do
          column :title
          column 'Description' do |result|
            truncate(result.description, length: 100)
          end
          column 'Selected?' do |result|
            [result.selected?, ("(#{result.selected_at})" if result.selected?)].join(' ')
          end
          column :position
        end
      end
    end
    
    unless search.comments.empty?
      panel 'Comments' do
        table_for search.comments do
          column 'Created', :created_at
          column :rating
          column :comment
        end
      end
    end
    
    default_main_content
  end
end
