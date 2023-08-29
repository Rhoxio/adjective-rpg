# frozen_string_literal: true

require_relative "version"
require "active_record"
require 'thor'
require 'awesome_print'

require_relative "modules/vulnerable"
require_relative "modules/imbibable"
require_relative "utils/string_patches"
require_relative "templates/add_columns_migration"
require_relative "templates/create_table_migration"
require_relative "templates/create_adjective_class"

module Adjective

  if defined?(Rails)
    require 'railties' 
    require_relative "railties"
    require_relative "generators/setup_generator"
    # ActiveSupport.on_load(:active_record) do
    #   extend Adjective::Models
    # end    
  end

  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :use_active_record, :config_file_path, :root, :migration_path, :models_path, :use_rails

    def initialize
      @use_active_record = true
      @use_rails = defined?(Rails) ? true : false
      # Need to set this up to ensure that if AR is off, it doesn't auto-set shit.

      @root = use_rails ? Rails.root : ""

      @config_file_path = "#{root}/config/initializers/adjective.rb"
      @migration_path = "#{root}/db/migrate"
      @models_path = "#{root}/app/models"
    end

    def set_new_root(root_path)
      @root = root_path
      @config_file_path = "#{root_path}/config/initializers/adjective.rb"
      @migration_path = "#{root_path}/db/migrate"
      @models_path = "#{root_path}/app/models"      
    end

  end

end


