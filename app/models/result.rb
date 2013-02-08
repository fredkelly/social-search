class Result < ActiveRecord::Base
  attr_accessible :title, :url, :description, :position, :search_id, :selected_at, :source_engine
  
  belongs_to :search, dependent: :destroy
  
  validates :title, :url, presence: true
  
  # order by position
  default_scope order: 'position ASC'
  
  scope :selected, where('selected_at IS NOT NULL')
  
  # perform scraping if required by source Engine
  before_create :scrape_page, if: Proc.new { self.source_engine::SCRAPED }
  
  def selected
    self.selected_at = Time.now
  end
  
  def selected!
    selected && save!
  end
  
  def selected?
    !selected_at.nil?
  end
  
  def page
    @page ||= Page.get(url)
  end
  
  # Set attributes sourced from scraped page
  def scrape_page
    self.url          = page.url # gives a resolved url
    self.title        = page.title
    self.description  = page.description
  end
  
  # convert to constant
  def source_engine
    super.constantize
  end
  
  # store as string
  def source_engine=(engine)
    super(engine.to_s)
  end
end
