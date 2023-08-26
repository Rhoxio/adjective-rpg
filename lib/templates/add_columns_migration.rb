class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

module Adjective
  class AddColumnsMigration
    attr_reader :module_classes, :modules, :class_name


    def initialize(class_name, modules = [])
      # raise ArgumentError, "Provided class_name of: #{class_name} was not a valid String." if (!!class_name || !class_name.is_a?(String)) 
      @class_name = class_name
      @modules = modules.map{|m| m&.downcase}
      @version = "7.0"
      @module_classes = given_modules
    end

    def generate_migration_class
      modules_string = @modules.map {|m| m.capitalize}.join("And")
      "Add#{modules_string}To#{@class_name.capitalize}"
    end

    def generate_file_name
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      migration_name = generate_migration_class.underscore
      return "#{timestamp}_#{migration_name}.rb"
    end

    def given_modules
      @modules.map do |mod|
        klass = "Adjective::#{mod.capitalize}".constantize
      end
    end

    def generate_attribute_fields
      @module_classes.map do |mod|
        mod.adjective_add_columns(@class_name)
      end.join("\n")
    end

    def generate_attribute_down_fields
      generate_attribute_fields.gsub("add_column", "remove_column")
    end

    def base_template
      <<~TEMPLATE
        class {{migration_class}} < ActiveRecord::Migration[{{version}}]
          def up
            {{add_methods}}
          end

          def down
            {{remove_methods}}
          end
        end
      TEMPLATE
    end

    def render
      base = base_template
      base
        .gsub("{{migration_class}}", generate_migration_class.lstrip)
        .gsub("{{add_methods}}", generate_attribute_fields.lstrip)
        .gsub("{{remove_methods}}", generate_attribute_down_fields.lstrip)
        .gsub("{{version}}", @version)
    end


  end
end