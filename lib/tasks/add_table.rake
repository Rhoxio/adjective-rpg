require "adjective"

# rake adjective:scaffold_for -- model=Character config_path=spec/plain_dummy/adjective include=Vulnerable,Imbibable

def invalid_modules?(modules)
  modules.blank? || modules.size == 0 || modules.include?("include")
end

def model_invalid?(model)
  (!model || model.blank? || model == "model")
end

namespace :adjective do 
  desc "Create a Migration and Model with ActiveRecord included based on Adjective modules provided"
  task :scaffold_for do 

    model = ARGV.find { |arg| arg.include?("model=") }&.split("=")&.last
    raise ArgumentError, "\e[33mPlease provide a target model using the 'model=' argument.\e[0m" if model_invalid?(model)

    config_install_path = ARGV.find { |arg| arg.include?("config_path=") }&.split("=")&.last || ADJECTIVE_DEFAULT_CONFIG_PATH
    rails_load_path = ARGV.find { |arg| arg.include?("rails_load_path=") }&.split("=")&.last || RAILS_DEFAULT_LOAD_PATH
    given_modules = ARGV.find { |arg| arg.include?("include=") }&.split("=")&.last || []

    if invalid_modules?(given_modules)
      puts "\e[33mYou are about to create a migration and model named #{model.capitalize} without any modules included with the 'include=' option. This will create a migration without attributes and a model without 'include' statements. \nDo you wish to continue? [Y/n]\e[0m"
      response = STDIN.gets.strip
      abort("\e[31mCancelled migration generation.\e[0m") unless response.downcase == "y"
    end

    modules = !invalid_modules?(given_modules) ? given_modules&.split(",")&.map{|mod| mod.strip} : []

    adj_config = File.join(Dir.pwd, config_install_path)
    rails_environment_path = File.join(Dir.pwd, rails_load_path)

    raise Errno::ENOENT, "\e[33mAdjective config file was not found at: #{adj_config}. Please check the relative path set in the 'config_install_path=' option and try again.\e[0m" unless File.exists?(adj_config+".rb")

    require adj_config

    if Adjective.configuration.use_rails
      require rails_environment_path
      Adjective.configuration.set_new_root(Rails.root)
    end

    generator = Adjective::CreateTableMigration.new(model, modules)
    migration_class = generator.render
    
    class_generator = Adjective::CreateAdjectiveClass.new(model, modules)
    new_class_file = class_generator.render

    new_migration_path = File.join(Adjective.configuration.migration_path, generator.file_name)
    new_model_path = File.join(Adjective.configuration.models_path, class_generator.file_name)    

    if File.exists?(new_model_path)
      puts "\e[33mRunning this command will delete and re-create your model file in: #{new_model_path}. Are you sure that you want to completely override the file?\n\nYou can add new columns to a table by using 'adjective:columns_for' instead.\n\nARE YOU ABSOLOUTELY SURE YOU WANT THE MODEL FILE GONE? [Y/n]\e[0m"
      response = STDIN.gets.strip
      abort("\e[31mCancelled migration and model generation.\e[0m") unless response.downcase == "y"
    end

    begin
      if !File.directory?(Adjective.configuration.migration_path)
        raise Errno::ENOENT, "\e[33mAdjective migration dir not found: #{Adjective.configuration.migration_path}. \n
        Please ensure that this directory exists and that the Adjective config file contains 'config.migration_path=' with the correct full path set.\e[0m" 
      end
      File.open(new_migration_path, 'w') do |file|
        file.write(migration_class)
      end
      puts "\e[32mCreated migration in: #{File.join(config_install_path, generator.file_name)}\e[0m"
    rescue => e
      puts "\e[31mError occured while generating the Adjective migration: #{e.message}\e[0m"
    end 

    begin
      if !File.directory?(Adjective.configuration.models_path)
        raise Errno::ENOENT, "Adjective models dir not found: #{Adjective.configuration.models_path}. \n
        Please ensure that this directory exists and 'config.models_path=' with the correct full path set."
      end
      File.open(new_model_path, 'w') do |file|
        file.write(new_class_file)      
      end
      puts "\e[32mNew model created at: #{new_model_path}\e[0m"
    rescue => e
      puts "\e[31mError occured while generating the Adjective model: #{e.message}\e[0m"
    end    

  end
end