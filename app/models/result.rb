class Result < ActiveRecord::Base
  attr_accessible :title, :url, :description, :position, :search_id, :selected_at, :source_engine, :media_urls
  
  belongs_to :search, dependent: :destroy, touch: true, counter_cache: true
  
  validates :url, :title, :description, presence: true
  validate :has_page?
  
  #validates_length_of :description, minimum: 20
  
  # NB: will validate on short URL before resolved URL is saved
  validates_uniqueness_of :url, scope: [:search_id], message: "URL %{value} already found in this search."
    
  # order by position
  default_scope order: 'position ASC'
  
  scope :selected, where('selected_at IS NOT NULL')
  
  # perform scraping if required by source Engine
  before_validation :scrape_page, if: Proc.new { self.url && self.source_engine::SCRAPED }, on: :create
  
  # array of image urls
  serialize :media_urls
  
  # statistics
  define_calculated_statistic :average_selections do
    (selected.size / all.size).to_f
  end
  
  # + 1 as positions are zero-indexed
  define_statistic :average_selected_position, average: :selected, column_name: 'position + 1'
  
  # PostgreSQL dependent!
  define_statistic :average_time_to_select, average: :selected, joins: :search,
    column_name: 'EXTRACT(EPOCH FROM (selected_at - searches.created_at))'
  
  def selected
    self.selected_at ||= Time.now
  end
  
  def selected!
    selected && save!
  end
  
  def selected?
    !selected_at.nil?
  end
  
  # add attribute and add to before_save filter?
  def time_to_select
    selected_at - search.created_at
  end
  
  def page
    @page ||= Page.get(url)
  end
  
  # checks if page is accessible
  # TODO: reject non-200 response codes?
  def has_page?
    if page.nil? || page.document.nil?
      errors.add(:page, "can not be nil")
      return false
    end
    true
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
  
  def has_media?
    !media_urls.empty?
  end
end
