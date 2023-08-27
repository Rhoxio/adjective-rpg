class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end

require_relative "adjective"
Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require file }

# p Enemy


module PlainDummy
  class Character
    def initialize
      ap __FILE__
      ap "plain dummy loaded"
    end
  end
end