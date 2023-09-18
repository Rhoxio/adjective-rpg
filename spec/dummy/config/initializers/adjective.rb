require "adjective"
Adjective.configure do |config|
  config.use_active_record = true
  config.use_rails = true
end

Adjective.experience_table = [0, 100, 200, 400, 800, 1600, 3200, 6400, 12800]