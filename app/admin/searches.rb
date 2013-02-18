ActiveAdmin.register Search do
  index do
    column 'ID', :id
    column 'Created', :created_at
    column 'Updated', :updated_at
    column 'Results #' do |search|
      search.results.size # needs count-caching (link?)
    end
  end
end
