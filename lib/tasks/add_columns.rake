require "adjective"

# rake adjective:add_columns_for -- model=Character config_path=spec/plain_dummy/adjective include=Vulnerable,Imbibable
# rake adjective:add_columns_for -- model=Character config_path=spec/dummy/config/initializers/adjective rails_load_path=spec/dummy/config/environment include=Vulnerable,Imbibable


# RAILS_DEFAULT_LOAD_PATH = 'config/environment'
# ADJECTIVE_DEFAULT_CONFIG_PATH = "config/initializers/adjective"

def invalid_modules?(modules)
  modules.blank? || modules.size == 0 || modules.include?("include")
end

def model_invalid?(model)
  (!model || model.blank? || model == "model")
end

namespace :adjective do 

  desc "Create a migration to add columns to an ActiveRecord model that uses Adjective behaviors."
  task :add_columns_for do 
    model = ARGV.find { |arg| arg.include?("model=") }&.split("=")&.last
    raise ArgumentError, "\e[33mPlease provide a target model using the 'model=' argument.\e[0m" if model_invalid?(model)

    config_install_path = ARGV.find { |arg| arg.include?("config_path=") }&.split("=")&.last || ADJECTIVE_DEFAULT_CONFIG_PATH
    rails_load_path = ARGV.find { |arg| arg.include?("rails_load_path=") }&.split("=")&.last || RAILS_DEFAULT_LOAD_PATH
    given_modules = ARGV.find { |arg| arg.include?("include=") }&.split("=")&.last || []

    if invalid_modules?(given_modules)
      puts "\e[33mYou are about to create a migration for #{model.capitalize} without any modules included with the 'include=' option. This will create a blank migration. \nDo you wish to continue? [Y/n]\e[0m"
      response = STDIN.gets.strip
      abort("\e[31mCancelled migration generation.\e[0m") unless response.downcase == "y"
    end

    modules = !invalid_modules?(given_modules) ? given_modules&.split(",")&.map{|mod| mod.strip} : []

    adj_config = File.join(Dir.pwd, config_install_path)
    rails_environment_path = File.join(Dir.pwd, rails_load_path)

    raise Errno::ENOENT, "Adjective config file was not found at: #{adj_config}. Please check the relative path set in the 'config_install_path=' option and try again." unless File.exists?(adj_config+".rb")

    require adj_config

    if Adjective.configuration.use_rails
      require rails_environment_path
      Adjective.configuration.set_new_root(Rails.root)
    end

    if !File.directory?(Adjective.configuration.migration_path)
      raise Errno::ENOENT, "\e[33mAdjective migration path was invalid. Given: #{Adjective.configuration.migration_path}\nThis can be set using an absolute path in Adjective.config block's 'migration_path=' method. e.x. /Users/USERNAME/Desktop/my_project/db/migrate\e[0m"
    end

    generator = Adjective::AddColumnsMigration.new(model, modules)
    migration_class = generator.render

    new_migration_path = File.join(Adjective.configuration.migration_path, generator.file_name)
    
    begin
      if !File.directory?(Adjective.configuration.migration_path)
        raise Errno::ENOENT, "Adjective migration dir not found: #{Adjective.configuration.migration_path}. \n
        Please ensure that this directory exists and that the Adjective config file contains 'config.migration_path=' with the correct full path set." 
      end
      File.open(new_migration_path, 'w') do |file|
        file.write(migration_class)
      end
      puts "\e[32mCreated migration in: #{File.join(config_install_path, generator.file_name)}\e[0m"
    rescue => e
      puts "\e[31mError occured while generating the Adjective migration: #{e.message}\e[0m"
    end         

  end
end