require_relative "lib/adjective"
require 'awesome_print'
# loaded_feature = $LOADED_FEATURES.find { |feature| feature.include?('lib/adjective.rb') }
loaded_feature = $LOADED_FEATURES.find { |feature| feature.include?('awesome_print') }
ap loaded_feature

Dir[File.join(File.dirname(__FILE__), 'lib', 'tasks', '**', '*.thor')].each do |thor_file|
  load thor_file
end