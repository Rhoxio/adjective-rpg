require_relative "../lib/adjective"
require "awesome_print"
require 'database_cleaner'
require_relative "support/file_manager"

Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

# DATABASE_NAME = 'adjective_plain_test' 
# database_config = {
#   adapter: 'postgresql',
#   host: 'localhost',
#   database: 'postgres',
#   username: ENV["DATABASE_USER"],
#   password: '',
#   port: 5432
# }

# ActiveRecord::Base.establish_connection(database_config)

# if ActiveRecord::Base.connection.select_value("SELECT 1 FROM pg_database WHERE datname = '#{DATABASE_NAME}'") != 1
#   ActiveRecord::Base.connection.create_database(DATABASE_NAME)
# elsif ActiveRecord::Base.connection.select_value("SELECT 1 FROM pg_database WHERE datname = '#{DATABASE_NAME}'") == 1
#   ActiveRecord::Base.connection.recreate_database(DATABASE_NAME)
# else
#   puts "Something went wrong... because the database is a Schrodinger"
# end

# ActiveRecord::Base.establish_connection(database_config.merge(database: DATABASE_NAME))

RSpec.configure do |config|

  # config.before(:suite) do
  #   DatabaseCleaner.clean_with(:truncation)
  #   Dir[File.join("/Users/maze/Desktop/adjective-rpg/spec/plain_dummy/db/migrate", '*.rb')].each do |file|
  #     require file

  #     migration_class_name = File.basename(file, '.rb').split("_").drop(1).join("_").camelize
  #     migration_class = migration_class_name.constantize
  #     migration_class.new.migrate(:up)
  #   end
  # end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end