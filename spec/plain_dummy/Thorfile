require "adjective"
loaded_feature = $LOADED_FEATURES.find { |feature| feature.include?('adjective') }
lib_dir = File.dirname(loaded_feature)

Dir[File.join(lib_dir, 'tasks', '**', '*.thor')].each do |thor_file|
  load thor_file
end