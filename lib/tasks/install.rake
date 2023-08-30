require "adjective"

namespace :adjective do 
  desc "Generate the initial Adjective config file"
  task :install do 
    # plain_dummy install command:
    # rake adjective:install -- config_path=spec/plain_dummy/ thorfile_path=spec/plain_dummy/

    # dummy install command:
    # rake adjective:install -- config_path=spec/dummy/config/initializers thorfile_path=spec/dummy/

    config_install_path = ARGV.find { |arg| arg.include?("config_path=") }&.split("=")&.last || "config/initializers"
    thorfile_install_path = ARGV.find { |arg| arg.include?("thorfile_path=") }&.split("=")&.last || Dir.pwd

    loaded_feature = $LOADED_FEATURES.find { |feature| feature.include?('adjective') }
    adj_config_location = File.join(File.dirname(loaded_feature), 'templates/static/adjective.rb')     

    begin
      if !File.directory?(config_install_path)
        raise Errno::ENOENT, "Adjective config install dir not found: #{config_install_path}. Please ensure that this directory exists." 
      end
      FileUtils.cp(adj_config_location, config_install_path)
      puts "\e[32mInstalled the Adjective configs to: #{File.join(config_install_path, "adjective.rb")}\e[0m"
    rescue => e
      puts "\e[31mError occured while copying the Adjective config file: #{e.message}\e[0m"
    end   

  end
end