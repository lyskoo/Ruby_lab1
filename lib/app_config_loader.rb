require 'yaml'
require 'erb'

module MyApplicationLysko
  class AppConfigLoader
    def self.load_config
      YAML.load(ERB.new(File.read(File.join(File.dirname(__FILE__), '../config/default_config.yaml'))).result)
    end

    def self.load_web_parser_config
      file_path = File.join(BASE_DIR, 'config', 'config.yml')
      YAML.load(ERB.new(File.read(file_path)).result)
    end

    def self.load_logging_config
      file_path = File.join(BASE_DIR, 'config', 'logging_config.yaml')
      YAML.load(ERB.new(File.read(file_path)).result)
    end
  end
end
