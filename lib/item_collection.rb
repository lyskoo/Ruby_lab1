require 'json'
require 'csv'
require 'yaml'

module MyApplicationLysko
  module ItemContainer
    module ClassMethods

      def class_info
        "#{self.name}"
      end

      def total_created_objects
        @total_created_objects ||= 0
      end

      def increment_created_objects
        @total_created_objects = total_created_objects + 1
      end
    end

    module InstanceMethods
      def add_item(item)
        @items << item
      end

      def remove_item(item)
        @items.delete(item)
      end

      def delete_items
        @items.clear
      end

      def method_missing(method_name, *args, &block)
        if method_name == :show_all_items
          @items.each { |item| puts item.info }
        else
          super
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end
  end

  class ItemCollection
    include ItemContainer
    include Enumerable

    attr_accessor :items

    def initialize
      @items = []
      self.class.increment_created_objects
    end

    # Метод each для підтримки Enumerable
    def each(&block)
      @items.each(&block)
    end

    def save_to_file(filename)
      File.open(filename, 'w') do |file|
        @items.each { |item| file.puts(item.to_s) }
      end
    end

    def save_to_json(filename)
      File.write(filename, @items.map(&:to_h).to_json)
    end

    def save_to_csv(filename)
      CSV.open(filename, 'w', headers: true) do |csv|
        csv << @items.first.to_h.keys if @items.any?
        @items.each { |item| csv << item.to_h.values }
      end
    end

    def save_to_yml(directory)
      Dir.mkdir(directory) unless Dir.exist?(directory)
      @items.each_with_index do |item, index|
        File.write("#{directory}/item_#{index + 1}.yml", item.to_h.to_yaml)
      end
    end

    def generate_test_items(count)
      count.times { add_item(Item.generate_fake) }
    end
  end
end
