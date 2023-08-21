# frozen_string_literal: true

require_relative "version"

module Adjective
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :use_active_record

    def initialize
      @use_active_record = false
    end
  end
end
