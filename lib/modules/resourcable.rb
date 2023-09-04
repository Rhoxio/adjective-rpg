module Adjective
  module Resourcable
    def init_resourcable

    end

    def define_imbibable_instance_variables(args)
      args.each do |key, value|
        self.class.send(:attr_accessor, key)
        self.instance_variable_set("@#{key.to_s}", value)
      end 
    end    
  end
end