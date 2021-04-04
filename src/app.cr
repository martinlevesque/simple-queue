require "./logger"

module App
  @@log_level = ENV.has_key?("LOG_LEVEL") ? ENV["LOG_LEVEL"] : "DEBUG"
  @@my_logger = Logger.new(@@log_level)

  def self.logger
    @@my_logger
  end
end
