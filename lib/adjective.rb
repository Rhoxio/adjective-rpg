# frozen_string_literal: true

require_relative "version"
require "active_record"
require_relative "models/actor"
require_relative "modules/vulnerable"
require_relative "models/application_record"
require_relative "utils/migration_renderer"
require 'awesome_print'

module Adjective

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
      
      @config_file_path = "config/adjective.yml"
      @config_file = read_config_file
      @use_active_record = false
    end

    def read_config_file
      YAML.load_file(@config_file_path)
    end

    def config_for(klass)
      config_file["class_options"][klass]
    end

    def mixins_for(klass)
      config_file["class_options"][klass]["include"]
    end

    def set_config_file_path(dir)
      @config_file_path = dir
      @config_file = read_config_file

      # Adding this here for the moment...
      @use_active_record = read_config_file['use_active_record']
    end

  end

end


