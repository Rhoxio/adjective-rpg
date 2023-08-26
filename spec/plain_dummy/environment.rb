require_relative "adjective"

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end

module PlainDummy
  class Character
    def initialize
      ap "plain dummy loaded"
    end
  end
end