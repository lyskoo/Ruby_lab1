BASE_DIR = File.expand_path('../../', __FILE__)

require_relative 'app_config_loader'
require_relative 'logger_manager'
require_relative 'item'
require_relative 'simple_website_parser'
require 'nokogiri'


module MyApplicationLysko
  def self.run
    config_file = File.expand_path('../../config/config.yml', __FILE__)
    
    parser = SimpleWebsiteParser.new(config_file)
    parser.parse_page
  end
end

MyApplicationLysko.run