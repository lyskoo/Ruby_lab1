module MyApplicationLysko
  
  class Configurator
    attr_accessor :config

    DEFAULT_CONFIG = {
      run_website_parser: 0,
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

    def execute
      @config.each do |key, value|
        next unless value == 1

        case key
        when :run_website_parser
          puts 'Запускається розбір сайту...'
        when :run_save_to_csv
          puts 'Дані зберігаються у форматі CSV...'
        when :run_save_to_json
          puts 'Дані зберігаються у форматі JSON...'
        when :run_save_to_yaml
          puts 'Дані зберігаються у форматі YAML...'
        when :run_save_to_sqlite
          puts 'Дані зберігаються в базу SQLite...'
        else
          puts "Невідома дія для ключа: #{key}"
        end
      end
    end
  end
end
