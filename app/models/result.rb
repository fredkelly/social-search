class Result < ActiveRecord::Base
  attr_accessible :title, :description, :position, :search_id, :selected_at, :source_engine, :url
  
  belongs_to :search
  
  # validations?
  
  # order by created
  default_scope :order => 'position ASC'
  
  def selected
    self.selected_at = Time.now
  end
  
  def selected!
    selected && save!
  end
  
  def selected?
    !selected_at.nil?
  end
end
