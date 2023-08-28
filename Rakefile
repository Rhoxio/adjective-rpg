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
