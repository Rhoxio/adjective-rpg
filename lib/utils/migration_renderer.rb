module Adjective
  class MigrationRenderer
    attr_accessor :base_migration_file

    def initialize
      @base_migration_file = File.read('lib/templates/base_migration.erb')
    end

    def render
      version = "7.0"
      migration_class = "CreateAllAdjectiveTables"
      @table_definitions = [
        { table_name: "actors", 
          attrs: [
            { attribute: "hitpoints",
              datatype: "integer"
            },
            {
              attribute: "max_hitpoints",
              datatype: "integer"
            }
          ]

        }
      ]
        
      erb = ERB.new(@base_migration_file, trim_mode: "-")
      erb.result(binding)
    end
  end
end