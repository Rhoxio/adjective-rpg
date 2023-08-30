module Adjective
  class CreateTableMigration
    attr_reader :module_classes, :modules, :class_name

    def initialize(class_name, modules = [])
      # raise ArgumentError, "Provided class_name of: #{class_name} was not a valid String." if (!!class_name || !class_name.is_a?(String)) 
      @class_name = class_name
      @modules = modules.map{|m| m&.downcase}
      @version = "7.0"
      @module_classes = given_modules
    end

    def class_name_sym
      ":#{@class_name.underscore.downcase}"
    end

    def migration_class
      modules_string = @modules.map {|m| m.capitalize}.join("And")
      "Create#{@class_name.camelize}With#{modules_string}"
    end

    def file_name
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      migration_name = migration_class.underscore
      return "#{timestamp}_#{migration_name}.rb"
    end

    def given_modules
      @modules.map do |mod|
        klass = "Adjective::#{mod.capitalize}".constantize
      end
    end  

    def columns
      @module_classes.map do |mod|
        mod.adjective_columns
      end.join("\n      ").chomp
    end

    def base_template
      <<~TEMPLATE
        class {{migration_class}} < ActiveRecord::Migration[{{version}}]
          def change
            create_table {{class_name}} do |t|
              {{create_columns}}
            end
          end
        end
      TEMPLATE
    end 

    def render
      base = base_template
      base
        .gsub("{{migration_class}}", migration_class.lstrip)
        .gsub("{{class_name}}", class_name_sym.lstrip)
        .gsub("{{create_columns}}", columns)
        .gsub("{{version}}", @version)
    end     
  end
end