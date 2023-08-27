# Module for experience gain
module Adjective
  module Imbibable
    def init_imbibable(args = {}, &block)
      if !Adjective.configuration.use_active_record
        define_imbibable_instance_variables(imbibable_default_data)
      end
    end

    def imbibable_default_data
      {
        experience: 0,
        level: 1
      }
    end

    def define_imbibable_instance_variables(args)
      args.each do |key, value|
        self.class.send(:attr_accessor, key)
        self.instance_variable_set("@#{key.to_s}", value)
      end 
    end    

    def self.adjective_columns
      <<-RUBY
      # Vulnerable Attributes
      t.integer :total_experience
      t.integer :level
      RUBY
    end

    def self.adjective_add_columns(klass)
      columns = <<-RUBY 
    # Imbibable Attributes
    add_column {{klass}}, :total_experience, :integer
    add_column {{klass}}, :level, :integer
      RUBY
      columns.gsub("{{klass}}", ":#{klass.downcase}")
    end       
  end
end