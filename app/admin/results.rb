ActiveAdmin.register Result do
  index do
    column 'ID', :id
    column 'Query' do |result|
      result.search.query
    end
    column 'Title', :title
    column 'Description' do |result|
      truncate(result.description, length: 100)
    end
    column 'Selected?' do |result|
      [result.selected?, ("(#{result.selected_at})" if result.selected?)].join(' ')
    end
    column :source_engine
  end
end
