# frozen_string_literal: true

require 'json'
require 'csv'
require 'yaml'
require 'sqlite3'
require_relative 'database_connector'

module MyApplicationLyskoLevitskii
  # ItemContainer реалізовує два модулі ClassMethods та InstanceMethods
  module ItemContainer
    # опис класу
    module ClassMethods
      # Повертає назву класу (ItemContainer)
      def class_info
        name.to_s
      end

      def total_created_objects
        @total_created_objects ||= 0
      end

      # скільки всього об'єктів класу створено
      def increment_created_objects
        @total_created_objects = total_created_objects + 1
      end
    end

    # опис методів класу
    module InstanceMethods
      def add_item(item)
        # << оператор додавання
        @items << item
      end

      def remove_item(item)
        @items.delete(item)
      end

      def delete_items
        @items.clear
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end
  end

  # Клас що представляє колекцію для Item
  class ItemCollection
    # імплементує ці модулі
    include ItemContainer
    include Enumerable

    # гетер і серер для items
    attr_accessor :items

    def initialize
      @items = []
      self.class.increment_created_objects
    end

    # Метод each для підтримки Enumerable
    def each(&block)
      @items.each(&block)
    end

    def save_to_json(filename)
      # спочатку перетворюємо в хеш
      File.write(filename, @items.map(&:to_h).to_json)
    end

    def save_to_csv(filename)
      CSV.open(filename, 'w', headers: true) do |csv|
        # Спочатку записуємо заголовки
        csv << @items.first.to_h.keys if @items.any?
        @items.each { |item| csv << item.to_h.values }
      end
    end

    def save_to_yml(filename)
      File.write(filename, @items.map(&:to_h).to_yaml)
    end

    def save_images(output_dir)
      FileUtils.mkdir_p(output_dir)
      @items.each do |item|
        # Пропускаємо, якщо шлях до зображення відсутній
        next unless item.image_path
        begin
          file_name = File.basename(item.image_path)
          local_file_path = File.join(output_dir, file_name)
          URI.open(item.image_path) do |image|
            File.open(local_file_path, 'wb') do |file|
              file.write(image.read)
            end
          end
        end
      end
    end

    def save_to_sqlite(database_path)
      connector = MyApplicationLyskoLevitskii::DatabaseConnector.new(database_path)
      # блок як try?
      begin
        @items.each do |item|
          connector.save_item(
            name: item.name,
            price: item.price,
            description: item.description
          )
        end
      # точно має виконатися
      ensure
        connector.close
      end
    end

    def generate_test_items(count)
      count.times { add_item(Item.generate_fake) }
    end
  end
end
