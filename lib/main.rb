BASE_DIR = File.expand_path('../../', __FILE__)

require_relative 'app_config_loader'
require_relative 'logger_manager'
require_relative 'item'
require_relative 'simple_website_parser'
require 'nokogiri'
require_relative 'database_connector'
require_relative 'item_collection'
require_relative 'configurator'


begin
  config = MyApplicationLysko::AppConfigLoader.load_config()

  parser = MyApplicationLysko::SimpleWebsiteParser.new
  collection = MyApplicationLysko::ItemCollection.new

  output_dir = File.join(BASE_DIR, 'output')

  # Налаштування Configurator
  configurator = MyApplicationLysko::Configurator.new
  configurator.configure(run_save_to_sqlite: 1)

  # Виконання задач за конфігурацією
  configurator.execute(parser: parser, collection: collection, output_dir: output_dir)

  puts 'Парсинг завершено. Дані збережено.'

rescue StandardError => e
  puts "Помилка: #{e.message}"
  puts e.backtrace.join("\n")
end