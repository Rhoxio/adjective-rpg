module Adjective
  module Vulnerable

    VULNERABLE_ATTRIBUTES = [:hitpoints, :max_hitpoints]

    # TODO: 

    # dont validate attrs - select valid ones, makes it more flexible. can pass
    # full attr objects through this way when setting up a model.

    # write the other logic

    def init_vulnerable(args = {}, &block)
      if !Adjective.configuration.use_active_record
        define_vulnerable_instance_variables(vulnerable_default_data)
      end
      yield(self) if block_given?
      # validate_vulnerable_attributes(args)
    end

    def vulnerable_default_data
      {
        hitpoints: 1,
        max_hitpoints: 10
      }
    end

    def set_vulnerable_data(args)

    end

    def define_vulnerable_instance_variables(args)
      args.each do |key, value|
        self.class.send(:attr_accessor, key)
        self.instance_variable_set("@#{key.to_s}", value)
      end 
    end

    def self.adjective_columns
      <<~RUBY
        # Vulnerable Attributes
        t.integer :hitpoints
        t.integer :max_hitpoints
      RUBY
    end

    def self.adjective_add_columns(klass)
      columns = <<-RUBY
    # Vulnerable Attributes
    add_column {{klass}}, :hitpoints, :integer
    add_column {{klass}}, :max_hitpoints, :integer
    RUBY
      columns.gsub("{{klass}}", ":#{klass.downcase}")
    end

    # private

    # def validate_vulnerable_attributes(args)
    #   if !args.keys.all? {|key| VALID_VULNERABLE_ATTRIBUTES.include?(key)}
    #     raise ArgumentError, "Provided invalid key as default attribute. Gave keys: #{args.keys}; valid keys are: #{VALID_VULNERABLE_ATTRIBUTES}"
    #   end
    # end

  end
end