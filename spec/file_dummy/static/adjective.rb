require "adjective"
Adjective.configure do |config|
  config.use_active_record = true
  config.migration_path = "/Users/maze/Desktop/adjective-rpg/spec/file_dummy/db/migrate"
  config.models_path = "/Users/maze/Desktop/adjective-rpg/spec/file_dummy/app/models/"
end