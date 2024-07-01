# frozen_string_literal: true

require_relative "version"
require "active_record"
require 'awesome_print'

require_relative "procs/capacitable_procs"
require_relative "modules/vulnerable"
require_relative "modules/imbibable"
require_relative "modules/resourcable"
require_relative "modules/capacitable"
require_relative "modules/vulnerable"
require_relative "models/hitpoints"
require_relative "utils/string_patches"

RAILS_DEFAULT_LOAD_PATH = 'config/environment'
ADJECTIVE_DEFAULT_CONFIG_PATH = "config/initializers/adjective"

module Adjective

  class Error < StandardError; end

  class << self
    attr_accessor :configuration
    attr_accessor :experience_table
    attr_accessor :callable

    @experience_table = []
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  def self.register_procs
    self.callable ||= Callable.new
    yield(callable) if block_given?
  end

  def self.registered_procs
    callable.namespaces
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

  class Callable
    attr_accessor :namespaces

    def initialize
      @namespaces = {}
      namespaces[:capacitable] = Adjective::CapacitableProcs.all
    end

    # They should be able to provide their own and override the namespaced
    # hashes alrady present if they want to. 
    
    # Might want to show a warning about this, but hey should also be able to disable the 
    # warning by setting a flag in the Adjective.register_procs block. 

    # Need to set this up so values in the namespace get merged with values from
    # the args inside of the same defined namespace.
    def namespace(given_namespace, &block)
      namespaces[given_namespace] = {} unless namespaces.key?(given_namespace)
      namespace = namespaces[given_namespace]
      yield(namespace) if block_given?
    end

  end


end


