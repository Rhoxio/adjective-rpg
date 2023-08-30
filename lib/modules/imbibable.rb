# Module for experience gain

# [String, Integer, Float].map {|t| p t.to_s.downcase}


module Adjective
  module Imbibable
    
    def init_imbibable(args = {}, &block)
      if !Adjective.configuration.use_active_record
        define_imbibable_instance_variables(self.default_data)
      end
    end

    def self.default_data
      {
        level: 1,
        total_experience: 0,
      }
    end

    def define_imbibable_instance_variables(args)
      args.each do |key, value|
        self.class.send(:attr_accessor, key)
        self.instance_variable_set("@#{key.to_s}", value)
      end 
    end

    include Adjective::Migratable      
  end
end