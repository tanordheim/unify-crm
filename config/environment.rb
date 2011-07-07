# Load the rails application
require File.expand_path('../application', __FILE__)

# Hack: log to both file and stdout to make the app simpler to manage when
# running in Docker. Just changing the Rails.logger to use STDOUT breaks some
# Rack stuff as some log-tailer-middleware is included by default by Rails -
# causing it to attempt to tail a non existent log file.
#
# Solution copied from https://stackoverflow.com/a/63222166
class LoggerProxy
  def initialize
    @loggers = Set.new
  end

  def add(logger)
    @loggers.add(logger)
  end

  def remove(logger)
    @loggers.delete(logger)
  end

  def method_missing(name, *args, &block)
    @loggers.each do |logger|
      logger.public_send(name, *args, &block)
    end
  end
end
Rails.logger = LoggerProxy.new
Rails.logger.add(Logger.new("log/#{Rails.env}.log", 10, 50.megabytes))
Rails.logger.add(Logger.new(STDOUT))

# Override (and quiet) Mongoid logging
Mongoid.logger = Logger.new(STDOUT)
Mongoid.logger.level = Logger::WARN
Moped.logger = Logger.new(STDOUT)
Moped.logger.level = Logger::WARN

# Initialize the rails application
Unify::Application.initialize!
