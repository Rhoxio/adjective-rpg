module Adjective
  class MigrationRenderer
    attr_accessor :base_migration_file

    def initialize
      @base_migration_file = File.read('lib/templates/base_migration.erb')
      # ap Adjective.configuration
    end

    def render
      validate_class_options
      version = "7.0"
      migration_class = "CreateAllAdjectiveTables"

      class_options = Adjective.configuration.read_config_file["class_options"]

      model_tables = {}

      class_options.each do |klass, modules|


        # So I think I should probably just nuke the newlines and do spacing in
        # the template itself? Break each line out and render those in a loop
        # on the same level of indentation I suppose.

        # This means that I need to split("\n") and push into array, then push into table_columns. 
        adj_class = "Adjective::#{klass.capitalize}".constantize.new
        adj_table_name = klass.downcase.pluralize
        table_columns = [adj_class.adjective_columns]

        modules["include"].each do |mod|
          mod_class = "Adjective::#{mod.capitalize}".constantize
          table_columns.push(mod_class.adjective_columns)
        end
        model_tables[adj_table_name] = table_columns

        
      end

      ap model_tables
      # @table_definitions = [
      #   { table_name: "actors", 
      #     attrs: [
      #       { attribute: "hitpoints",
      #         datatype: "integer"
      #       },
      #       {
      #         attribute: "max_hitpoints",
      #         datatype: "integer"
      #       }
      #     ]

      #   }
      # ]
        
      # erb = ERB.new(@base_migration_file, trim_mode: "-")
      # erb.result(binding)
    end

    private

    def validate_class_options
      return true if Adjective.configuration.read_config_file["class_options"].length > 0
      raise StandardError, "No class_options were available in: #{Adjective.configuration.config_file_path}."
    end


  end
end