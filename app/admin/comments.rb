ActiveAdmin.register Comment, as: 'Search Comment' do
  index do
    column 'ID', :id
    column 'Search' do |comment|
      link_to comment.search.query, admin_search_path(comment.search)
    end
    column :comment
    column :rating
    column 'Created', :created_at
  end
end
