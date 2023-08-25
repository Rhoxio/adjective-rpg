# frozen_string_literal: true

require_relative "version"
require_relative "railties"
require_relative "generators/setup_generator"
require "active_record"
# require_relative "models/actor"
require_relative "modules/vulnerable"
# require_relative "models/application_record"
require_relative "utils/migration_renderer"
require 'awesome_print'
require 'rails'

module Adjective

  require 'railties' if defined?(Rails)

  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  def self.build_class_definitions
    Adjective::DefineActor.construct
  end

  class Configuration
    attr_accessor :use_active_record, :config_file, :config_file_path

    def initialize
      @config_file_path = "#{Rails.root}/config/adjective.yml"
      @config_file = read_config_file
      @use_active_record = @config_file['use_active_record']
    end

    def read_config_file
      YAML.load_file(@config_file_path)
    end

    def set_config_file_path(dir)
      @config_file_path = dir
      @config_file = read_config_file

      # Adding this here for the moment...
      @use_active_record = read_config_file['use_active_record']
    end

  end

end


