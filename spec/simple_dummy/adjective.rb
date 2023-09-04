require "adjective"

root = "/Users/maze/Desktop/adjective-rpg/spec/simple_dummy/"
migration_path = "/Users/maze/Desktop/adjective-rpg/spec/simple_dummy/db/migrate"
models_path = "/Users/maze/Desktop/adjective-rpg/spec/simple_dummy/models"

Adjective.configure do |config|
  config.use_active_record = false
  config.use_rails = false
  config.config_file_path = __FILE__
  config.root = root
  config.migration_path = migration_path
  config.models_path = models_path
end

Adjective.experience_table = [0, 100, 200, 400, 800, 1600, 3200, 6400, 12800]


require_relative "models/surrogate"