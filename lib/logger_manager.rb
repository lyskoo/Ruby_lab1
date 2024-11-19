require 'logger'

module MyApplicationLysko
  
  class LoggerManager
    def self.setup
      config = AppConfigLoader.load_logging_config
      directory = config["logging"]["directory"]
      level = eval("Logger::#{config['logging']['level']}")
      logger = Logger.new(File.join(directory, config['logging']['files']['application_log']))
      logger.level = level
      logger
    end
  end
end