class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :search_id
      t.text :comment
      t.integer :rating

      t.timestamps
    end
  end
end
