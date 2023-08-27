root = "/Users/maze/Desktop/adjective-rpg/spec/plain_dummy/"
migration_path = "/Users/maze/Desktop/adjective-rpg/spec/plain_dummy/db/migrate"

Adjective.configure do |config|
  config.use_active_record = false
  config.config_file_path = __FILE__
  config.root = root
  config.migration_path = migration_path
end