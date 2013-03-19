ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    
    columns do
      column do
        panel "Recent Searches" do
          ul do
            Search.last(5).reverse.map do |search|
              li link_to "\"#{search.query}\"", admin_search_path(search) do
                span "#{time_ago_in_words(search.created_at)} ago"
              end
            end
          end
        end
      end
      
      column do
        panel "Recent Comments" do
          ul do
            Comment.where('comment != \'\'').last(5).reverse.map do |comment|
              li link_to "\"#{comment.comment}\" (#{comment.rating}/5)", admin_search_path(comment.search) do
                span "#{time_ago_in_words(comment.created_at)} ago"
              end
            end
          end
        end
      end
      
      column do
        panel "System Information" do
          para "Latest aggregate @ #{StatisticsAggregate.last.created_at rescue 'never'}."
        end
      end
    
    end
    
    unless StatisticsAggregate.count < 2
      columns do
        StatisticsAggregate.as_time_series(:all).each do |column, series|
          column do
            panel "#{StatisticsAggregate::FRIENDLY_NAMES[column]} (#{series.size} days)" do
              render 'graph', column: column, series: series
            end
          end
        end
      end
    end
    
                
  end # content
end
