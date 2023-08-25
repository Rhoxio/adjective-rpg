require 'rails/generators'

module Adjective
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)
      desc 'Creates an Adjective config file.'

      def copy_config
        template 'adjective.rb', "#{Rails.root}/config/initializers/adjective.rb"
      end      
    end
  end
end