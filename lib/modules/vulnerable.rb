module Adjective
  module Vulnerable

    # It should essentially assign hitpoints automatically and track them with Resourcable
    # This is going to have to process based on an internal var
    # because the Resourcable isn't aupposed to be here - it should be a base class that simply consumes
    # the functionality I think....

    VULNERABLE_ATTRIBUTES = [:hitpoints, :max_hitpoints]

    def init_vulnerable(args = {}, &block)
      define_vulnerable_instance_variables(vulnerable_default_data)
      yield(self) if block_given?
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

  end
end