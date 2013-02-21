class HerokuLogger < ActiveSupport::BufferedLogger
  def initialize
    super(Rails.root.join(Rails.env.production? ? 'log/production.log' : 'log/custom.log'))
  end
  
  def add(severity, message = nil, progname = nil, &block)
    mesage.gsub!("\n", "\n[CUSTOM]") if Rails.env.production?
    super(severity, message, progname, &block)
  end
end

# add colour methods to String
class String
  include Term::ANSIColor
end

CustomLogger = HerokuLogger.new