require 'thor'

# These are assumed to be run from the project root dir.

# Plain Generators for the Test Setup
# thor adjective:generate:columns_for Character --includes Vulnerable --config spec/plain_dummy/adjective
# thor adjective:generate:scaffold_for Enemy --includes Vulnerable --config spec/plain_dummy/adjective

# Rails Generators for Test Setup
# thor adjective:generate:scaffold_for Enemy --includes Vulnerable --config spec/dummy/config/initializers/adjective --rails_load_path ../../spec/dummy/config/environment
# thor adjective:generate:columns_for Enemy --includes Vulnerable --config spec/dummy/config/initializers/adjective --rails_load_path ../../spec/dummy/config/environment

module Adjective
  class AdjectiveTasks < Thor
    include Thor::Actions

    default_rails_load_path = './config/environment'

    package_name "adjective"
    namespace 'adjective:generate'

    desc "columns_for", "generates the needed migration columns for the supplied model and included modules"
    method_options :includes => :array
    method_options :config => :string
    method_options :rails_load_path => :string
    def columns_for(model)
      # This assumes that you are running the command from the root of your project when you pass in relative --config
      # into the generator. I might need to make it so you can fully override it with an ENV variable, but the relative
      # path works for the moment.

      # The main issue is that the Adjective configs need to be required. I have to construct an absolute path
      # in some sense because there's no guarantee that the defaults will always work.
      # I think having them set them in the configs and once in the generation scripts or in an env var is
      # perfectly reasonable. How else is the program supposed to know their custom file structure?

      config_file_path = ENV['ADJECTIVE_CONFIG_PATH'] ||= options[:config]
      adj_configs = File.join( Dir.pwd, config_file_path)
      rails_load_path = options[:rails_load_path] ||= default_rails_load_path

      require adj_configs
      if Adjective.configuration.use_rails
        require_relative rails_load_path
        Adjective.configuration.set_new_root(Rails.root)
      end

      modules = !!options[:includes] ? options[:includes] : []

      generator = Adjective::AddColumnsMigration.new(model, modules)
      migration_class = generator.render

      new_migration_path = File.join(Adjective.configuration.migration_path, generator.file_name)

      File.open(new_migration_path, 'w') do |file|
        file.write(migration_class)
      end
      say "Adjective migration created at: #{new_migration_path}", :green

    end

    desc "scaffold_for", "generates a class definition and the relevant migrations based on Adjective configs"
    method_options :includes => :array
    method_options :config => :string
    method_options :rails_load_path => :string
    def scaffold_for(model)
      config_file_path = ENV['ADJECTIVE_CONFIG_PATH'] ||= options[:config]
      adj_configs = File.join( Dir.pwd, config_file_path)
      rails_load_path = options[:rails_load_path] ||= default_rails_load_path

      require adj_configs

      if Adjective.configuration.use_rails
        require_relative rails_load_path
        Adjective.configuration.set_new_root(Rails.root)
      end
      
      modules = !!options[:includes] ? options[:includes] : []

      generator = Adjective::CreateTableMigration.new(model, modules)
      migration_class = generator.render

      class_generator = Adjective::CreateAdjectiveClass.new(model, modules)
      new_class_file = class_generator.render

      new_migration_path = File.join(Adjective.configuration.migration_path, generator.file_name)
      new_model_path = File.join(Adjective.configuration.models_path, class_generator.file_name)

      File.open(new_migration_path, 'w') do |file|
        file.write(migration_class)
        say "Adjective migration created at: #{new_migration_path}", :green      
      end      

      File.open(new_model_path, 'w') do |file|
        file.write(new_class_file)
        say "New model created at: #{new_model_path}", :green      
      end
      
    end

  end
end