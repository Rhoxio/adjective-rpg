# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'fileutils'
require_relative "./lib/adjective"
spec = Gem::Specification.find_by_name 'adjective-rpg'

Dir.glob("#{spec.gem_dir}/lib/tasks/**/*.rake").each { |f| import f }

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :spec do
  task :plain do
    system("rspec spec/adjective/plain_specs/** --require ./spec/adjective/plain_helper")
  end

  task :rails do
    system("rspec spec/adjective/rails_specs/** --require ./spec/adjective/rails_helper")
  end  

  task :simple do 
    system("rspec spec/adjective/simple_specs/** --require ./spec/adjective/simple_helper")
  end
end

namespace :build do 
  task :gem do 
    system("gem build adjective-rpg.gemspec")
    system("gem uninstall adjective-rpg")
    system("gem install adjective-rpg-#{Adjective::VERSION}.gem")
  end
end
