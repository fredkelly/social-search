ActiveAdmin.register Result do
  index do
    column 'ID' do |result|
      link_to result.id, admin_result_path(result)
    end
    column 'Query' do |result|
      result.search.query
    end
    column 'Title', :title
    column 'Description' do |result|
      truncate(result.description, length: 100)
    end
    column 'Selected?' do |result|
      [result.selected?, ("(in %0.2f secs)" % result.time_to_select if result.selected?)].join(' ')
    end
    column :position
    column :source_engine
  end
end
