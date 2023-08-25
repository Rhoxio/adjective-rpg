require 'adjective'

namespace :adjective do

  desc 'setup the initial config for Adjective'
  task :setup do 
    Adjective::Generators::SetupGenerator.new.copy_config
  end

  task :test do 
    ap Adjective
    path = ENV['ADJECTIVE_CONFIG_PATH']
    ap path
  end


  namespace :db do 
    desc 'generate all migrations from Adjective based on default settings'
    task :generate_all_tables do 
      path = ENV['ADJECTIVE_CONFIG_PATH'] ||= "config/adjective.yml"

      # Load a copy of Adjective with the correct configs.
      Adjective.configure do |config|
        config.set_config_file_path(path)
      end

      

      # template_migration_content = File.read('lib/templates/all_tables.rb')
      # timestamp = Time.now.strftime('%Y%m%d%H%M%S')

      # migration_name = "create_all_adjective_tables"
      # new_migration_file_name = "#{timestamp}_#{migration_name}.rb"
      # new_migration_path = File.join('db', 'migrate', new_migration_file_name)

      # File.open(new_migration_path, 'w') do |file|
      #   file.write(template_migration_content)
      # end

      # puts "Created Adjective Migration at: #{new_migration_path}"
    end
  end
end