ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= "#{File.dirname(__FILE__)}../../../spec/dummy"
require_relative "../../lib/adjective"
require "awesome_print"
require 'database_cleaner'
require_relative '../dummy/config/environment'
require_relative 'support/file_manager'


RSpec.configure do |config|
  config.include FileManager

  config.before(:suite) do
    # DatabaseCleaner.clean_with(:truncation)
    # Load the Rails application environment
    require_relative '../dummy/config/environment'

    # Get the database configuration
    db_config = Rails.application.config.database_configuration[Rails.env]

    # Drop the existing database
    ActiveRecord::Base.establish_connection(db_config.except('database'))
    ActiveRecord::Base.connection.drop_database(db_config['database'])

    # Recreate the database
    ActiveRecord::Base.connection.create_database(db_config['database'])

    # Re-establish connection and migrate the database
    ActiveRecord::Base.establish_connection(db_config)
    # ActiveRecord::Tasks::DatabaseTasks.load_schema(:ruby, ENV['SCHEMA'])
    ActiveRecord::MigrationContext.new('../dummy/db/migrate').migrate
  end 

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end   
end

