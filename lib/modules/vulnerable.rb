module Adjective
  module Vulnerable

    VULNERABLE_ATTRIBUTES = [:hitpoints, :max_hitpoints]

    def init_vulnerable(args = {}, &block)
      if !Adjective.configuration.use_active_record
        define_vulnerable_instance_variables(vulnerable_default_data)
      end
      yield(self) if block_given?
      # validate_vulnerable_attributes(args)
    end

    def self.default_data
      {
        hitpoints: 1,
        max_hitpoints: 10
      }
    end

    def define_vulnerable_instance_variables(args)
      args.each do |key, value|
        self.class.send(:attr_accessor, key)
        self.instance_variable_set("@#{key.to_s}", value)
      end 
    end

    include Adjective::Migratable 

  end
end