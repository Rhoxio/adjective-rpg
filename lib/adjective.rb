# frozen_string_literal: true

require_relative "version"
require_relative "railties"

# require_relative "included_models"
require "active_record"
require_relative "modules/vulnerable"
# require_relative "models/application_record"
require_relative "utils/migration_renderer"
require 'awesome_print'
require 'rails'

module Adjective

  if defined?(Rails)
    require 'railties' 
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

  # def self.build_class_definitions
  #   Adjective::DefineActor.construct
  # end

  class Configuration
    attr_accessor :use_active_record, :config_file, :config_file_path, :models_path

    def initialize
      root = defined?(Rails) ? Rails.root : "."
      models_path = defined?(Rails) ? "#{root}/app/models" : "app/models"

      @config_file_path = "#{root}/config/initializers/adjective.rb"
      @use_active_record = true
      @models_path = models_path
    end

  end

end


