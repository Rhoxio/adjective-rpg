root = "/Users/maze/Desktop/adjective-rpg/spec/plain_dummy/"
migration_path = "/Users/maze/Desktop/adjective-rpg/spec/plain_dummy/db/migrate"
models_path = "/Users/maze/Desktop/adjective-rpg/spec/plain_dummy/models"

Adjective.configure do |config|
  config.use_active_record = true
  config.use_rails = false
  config.config_file_path = __FILE__
  config.root = root
  config.migration_path = migration_path
  config.models_path = models_path
end