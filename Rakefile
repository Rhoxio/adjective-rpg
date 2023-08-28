# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'fileutils'
Dir.glob('lib/tasks/**/*.rake').each { |r| load r }

RSpec::Core::RakeTask.new(:spec)

task default: :spec
Rake::Task.define_task('adjective:db:generate_all_tables')

namespace :spec do
  task :plain do
    system("rspec spec/adjective/plain_specs/** --require ./spec/adjective/plain_helper")
  end

  task :rails do
    system("rspec spec/adjective/rails_specs/** --require ./spec/adjective/rails_helper")
  end  
end

namespace :build do 
  task :gem do 
    system("gem build adjective-rpg.gemspec")
    # system("gem install adjective-0.1.0.gem")
  end
end

# namespace :adjective do 
#   task :install do 
#     # plain_dummy install command:
#     # rake adjective:install -- config_path=spec/plain_dummy/ thorfile_path=spec/plain_dummy/

#     # dummy install command:
#     # rake adjective:install -- config_path=spec/dummy/config/initializers thorfile_path=spec/dummy/

#     config_install_path = ARGV.find { |arg| arg.include?("config_path=") }&.split("=")&.last || "config/initializers"
#     thorfile_install_path = ARGV.find { |arg| arg.include?("thorfile_path=") }&.split("=")&.last || Dir.pwd

#     loaded_feature = $LOADED_FEATURES.find { |feature| feature.include?('adjective') }
#     adj_thorfile_location = File.join(File.dirname(loaded_feature), 'templates/static/Thorfile')
#     adj_config_location = File.join(File.dirname(loaded_feature), 'templates/static/adjective.rb')    

#     begin
#       if !File.directory?(thorfile_install_path)
#         raise Errno::ENOENT, "Thorfile install dir not found: #{thorfile_install_path}. Please ensure that this directory exists." 
#       end
#       FileUtils.cp(adj_thorfile_location, thorfile_install_path)
#       puts "\e[32mInstalled the Adjective Thorfile to: #{File.join(thorfile_install_path, "Thorfile")}\e[0m"
#     rescue => e
#       puts "\e[31mError occured while copying the Adjective Thorfile: #{e.message}\e[0m"
#     end    

#     begin
#       if !File.directory?(config_install_path)
#         raise Errno::ENOENT, "Adjective config install dir not found: #{config_install_path}. Please ensure that this directory exists." 
#       end
#       FileUtils.cp(adj_config_location, config_install_path)
#       puts "\e[32mInstalled the Adjective configs to: #{File.join(config_install_path, "adjective.rb")}\e[0m"
#     rescue => e
#       puts "\e[31mError occured while copying the Adjective Thorfile: #{e.message}\e[0m"
#     end   

#   end
# end
