class AddMediaUrlsToResults < ActiveRecord::Migration
  def change
    add_column :results, :media_urls, :text
  end
end
