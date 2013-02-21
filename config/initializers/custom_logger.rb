CustomLogger = ActiveSupport::BufferedLogger.new(Rails.root.join('log/custom.log'))

# add colour methods to String
class String
  include Term::ANSIColor
end