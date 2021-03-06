class Comment < ActiveRecord::Base
  attr_accessible :comment, :rating, :search_id
  
  belongs_to :search
  
  validates :rating, inclusion: { in: 1..5 }
  #validates :comment, presence: true
  
  # statistics
  define_statistic :average_rating, average: :all, column_name: :rating
end
