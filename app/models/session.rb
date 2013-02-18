class Session < ActiveRecord::Base
  attr_accessible :session_id, :app_version, :accept, :accept_charset, :accept_language, :remote_addr, :user_agent
  
  has_many :searches, dependent: :destroy
  
  # Generates or retrieves instance based
  # on supplied <tt>ActionDispatch::Request</tt>.
  def self.find_or_create_by_request(request)
    where(session_id: request.session[:session_id], app_version: Rails.application.class::FILE_VERSION).first_or_initialize.tap do |session|
      [:accept, :accept_charset, :accept_language, :remote_addr, :user_agent].each do |key|
        session[key] = request.send(key)
      end
      session.referer ||= request.params[:referer] # use URI(request.referer).host ?
      session.app_version ||= Rails.application.class::FILE_VERSION
      session.save!
    end
  end
  
  # parse string into object
  # https://github.com/josh/useragent
  def user_agent
    UserAgent.parse(super)
  end
end
