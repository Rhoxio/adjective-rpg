require 'thor'

# thor adjective:generate:columns_for Character --includes Vulnerable --config spec/plain_dummy/adjective


class AdjectiveTasks < Thor
  package_name "adjective"
  include Thor::Actions
  namespace 'adjective:generate'

  desc "columns_for", "generates the needed migration columns for the supplied model and included modules"
  method_options :includes => :array
  method_options :config => :string
  def columns_for(model)
    config_file_path = ENV['ADJECTIVE_CONFIG_PATH'] ||= options[:config]
    dir = File.join( Dir.pwd, config_file_path)
    require dir
    modules = !!options[:includes] ? options[:includes] : []
    # p model
    # p options

    # ap Adjective.configuration
    Adjective::AddColumnsMigration.new(model, modules)


  end
end