module Adjective
  class CreateAdjectiveClass
    def initialize(class_name, modules = [])
      @class_name = class_name
      @modules = modules.map{|m| m&.downcase}
      @module_classes = given_modules
    end

    def file_class_name
      @class_name.capitalize
    end

    def file_name
      @class_name.downcase + ".rb"
    end

    def given_modules
      @modules.map do |mod|
        klass = "Adjective::#{mod.capitalize}".constantize
      end      
    end

    def modules_string
      @modules.map {|mod| "  include Adjective::#{mod.capitalize}"}.join("\n")
    end

    def inherited_classes
      return "< ApplicationRecord" if Adjective.configuration.use_active_record
      return ""
    end

    def base_template
      <<~TEMPLATE
      class {{class_name}} {{active_record_inheritance}}
      {{modules_string}}
      end
      TEMPLATE
    end

    def render
      base = base_template
      base
        .gsub("{{class_name}}", file_class_name.lstrip)
        .gsub("{{active_record_inheritance}}", inherited_classes.lstrip)
        .gsub("{{modules_string}}", modules_string)
    end

  end
end