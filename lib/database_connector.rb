require 'sqlite3'

module MyApplicationLysko
  class DatabaseConnector
    attr_reader :db

    def initialize(database_path)
      @db = SQLite3::Database.new(database_path)
      create_table
    end

    # Метод створення таблиці, якщо її ще немає
    def create_table
      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS items (
          id INTEGER PRIMARY KEY,
          name TEXT,
          price REAL,
          description TEXT
        );
      SQL
    end

    # Метод для збереження запису
    def save_item(item)
      @db.execute(
        "INSERT INTO items (name, price, description) VALUES (?, ?, ?)",
        [item[:name], item[:price], item[:description]]
      )
    end

    # Метод закриття підключення
    def close
      @db.close if @db
    end
  end
end
