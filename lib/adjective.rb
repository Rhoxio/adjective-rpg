# frozen_string_literal: true

require_relative "version"
require "active_record"
require_relative "models/actor"
require_relative "modules/vulnerable"
require_relative "models/application_record"
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
    attr_accessor :use_active_record

    def initialize
      @use_active_record = false
    end
  end

  self.configure

end


