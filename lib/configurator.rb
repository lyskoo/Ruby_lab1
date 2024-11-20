require_relative 'database_connector'

module MyApplicationLysko
  class Configurator
    attr_accessor :config

    DEFAULT_CONFIG = {
      run_website_parser: 1,
      run_save_to_csv: 0,
      run_save_to_json: 0,
      run_save_to_yaml: 0,
      run_save_to_sqlite: 0,
    }.freeze

    def initialize
      @config = DEFAULT_CONFIG.dup
    end

    def configure(overrides = {})
      overrides.each do |key, value|
        if @config.key?(key)
          @config[key] = value
        else
          puts "Попередження: Ключ '#{key}' не є дійсним параметром конфігурації."
        end
      end
    end

    def self.available_methods
      DEFAULT_CONFIG.keys
    end

    def execute(parser: nil, collection: nil, output_dir: nil)
      @config.each do |key, value|
        next unless value == 1

        case key
        when :run_website_parser
          puts 'Запускається розбір сайту...'
          raise 'Parser is not provided!' if parser.nil?

          items = parser.parse_page
          items.each { |item| collection.add_item(item) }
        when :run_save_to_csv
          puts 'Дані зберігаються у форматі CSV...'
          collection.save_to_csv("#{output_dir}/items.csv")
        when :run_save_to_json
          puts 'Дані зберігаються у форматі JSON...'
          collection.save_to_json("#{output_dir}/items.json")
        when :run_save_to_yaml
          puts 'Дані зберігаються у форматі YAML...'
          collection.save_to_yml("#{output_dir}/items.yml")
        when :run_save_to_sqlite
          puts 'Дані зберігаються в базу SQLite...'
          save_to_sqlite(collection, "#{output_dir}/items.sqlite")
        else
          puts "Невідома дія для ключа: #{key}"
        end
      end
    end

    private

    def save_to_sqlite(collection, database_path)
      connector = MyApplicationLysko::DatabaseConnector.new(database_path)
      begin
        collection.items.each do |item|
          connector.save_item(
            name: item.name,          # Використання геттерів
            price: item.price,        # Використання геттерів
            description: item.description # Використання геттерів
          )
        end
        puts 'Дані успішно збережено в базу даних.'
      ensure
        connector.close
      end
    end
  end
end
