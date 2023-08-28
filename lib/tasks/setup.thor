module Adjective
  class AdjectiveSetup < Thor
    # thor adjective:setup --config_path spec/file_dummy/config/initializers
    
    include Thor::Actions
    require "fileutils"

    package_name "adjective"
    namespace 'adjective'

    desc "setup", "Creates the needed files for Adjective"
    method_options :config_path => :string
    method_options :thorfile_path => :string
    def setup
      config_install_path = options[:config_path] || "config/initializers"
      thorfile_install_path = options[:thorfile_path] || Dir.pwd
      template_path = File.expand_path('../templates/static/adjective.rb', __dir__) 

      loaded_feature = $LOADED_FEATURES.find { |feature| feature.include?('adjective') }
      adj_thorfile_location = File.join(File.dirname(loaded_feature), 'templates/static/Thorfile')
      adj_config_location = File.join(File.dirname(loaded_feature), 'templates/static/adjective.rb')        

      begin
        if !File.directory?(config_install_path)
          raise Errno::ENOENT, "Adjective config install dir not found: #{config_install_path}. Please ensure that this directory exists." 
        end
        FileUtils.cp(template_path, config_install_path)
        puts "\e[32mInstalled the Adjective configs to: #{File.join(config_install_path, "adjective.rb")}\e[0m"
      rescue => e
        puts "\e[31mError occured while copying the Adjective config: #{e.message}\e[0m"
      end 

      begin
        if !File.directory?(thorfile_install_path)
          raise Errno::ENOENT, "Thorfile install dir not found: #{thorfile_install_path}. Please ensure that this directory exists." 
        end
        FileUtils.cp(adj_thorfile_location, thorfile_install_path)
        puts "\e[32mInstalled the Adjective Thorfile to: #{File.join(thorfile_install_path, "Thorfile")}\e[0m"
      rescue => e
        puts "\e[31mError occured while copying the Adjective Thorfile: #{e.message}\e[0m"
      end 
    end
  end
end