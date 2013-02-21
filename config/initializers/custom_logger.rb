CustomLogger = ActiveSupport::BufferedLogger.new(Rails.env.production? ? Rails.root.join('log/custom.log') : $STDOUT)

# disable all logging for demonstration
if Rails.env.production?
  ActiveRecord::Base.logger = nil
end

# add colour methods to String
class String
  include Term::ANSIColor
end