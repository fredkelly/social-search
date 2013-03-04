class Session < ActiveRecord::Base
  attr_accessible :session_id, :app_version, :accept, :accept_charset, :accept_language, :remote_ip, :user_agent
  
  has_many :searches, dependent: :destroy
  validates :session_id, presence: true
  
  alias_attribute :to_s, :session_id
  
  # geocoding
  geocoded_by :remote_ip
  after_validation :geocode
  
  # statistics
  define_calculated_statistic :percentage_returning do
    (find_by_sql('SELECT DISTINCT ON (remote_ip) * FROM sessions').map(&:returning?).count(true) / all.size).to_f
  end
  
  # Generates or retrieves instance based
  # on supplied <tt>ActionDispatch::Request</tt>.
  def self.find_or_create_by_request(request)
    where(session_id: request.session[:session_id], app_version: Rails.application.class::FILE_VERSION).first_or_initialize.tap do |session|
      [:accept, :accept_charset, :accept_language, :remote_ip, :user_agent].each do |key|
        session[key] = request.send(key)
      end
      
      # ?ref=X or ?referer=X
      referer = request.params.slice(:referer, :ref).values.first
      session.referer = referer.blank? ? session.referer : referer
      
      # datetime of last push
      session.app_version ||= Rails.application.class::FILE_VERSION
      
      session.save!
    end
  end
  
  # parse string into object
  # https://github.com/toolmantim/user_agent_parser
  def user_agent
    UserAgentParser.parse(super)
  end
  
  def duration
    updated_at - created_at
  end
  
  def app_version_latest?
    app_version == Rails.application.class::FILE_VERSION
  end
  
  def previous_sessions
    self.class.unscoped.where(['remote_ip = ? AND id != ?', remote_ip, id])
  end
  
  # returning visit iff another session of the same
  # remote_ip exists at least a day in the past
  def returning?(since = 1.day.ago)
    !previous_sessions.where('created_at <= ?', since).empty?
  end
end
