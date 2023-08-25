# frozen_string_literal: true

require_relative "../lib/adjective"
require "awesome_print"
require 'database_cleaner'
require 'simplecov'
ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= "#{File.dirname(__FILE__)}../../../spec/dummy"
require_relative '../spec/dummy/config/environment'
require_relative 'adjective/support/file_manager'


# Adjective.configure do |config|
#   config.use_active_record = false
# end

RSpec.configure do |config|
  config.include FileManager

  config.before(:suite) do
    # DatabaseCleaner.clean_with(:truncation)
    # ActiveRecord::MigrationContext.new('db/migrate').migrate
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
