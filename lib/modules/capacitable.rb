module Adjective
  module Capacitable

    def collection
      self.public_send(collection_ref)
    end

    def replace_all!(array)
      self.public_send("#{collection_ref}=", array)
    end

    def query(args = {strategy: nil, ref: nil, term: "", custom_strategy: nil})
      given_strategy = capacitable_strategies[args[:strategy]] if !args[:custom_strategy]
      given_strategy = args[:custom_strategy] if args[:custom_strategy]
      matches = given_strategy.call(self, args)
      return matches
    end

    def store(items)
      items = Array(items)

      # collection << item if 
    end

    def has_space?
      collection.length < max_slots  
    end

    def remaining_slots
      max_slots - collection.length
    end

    def filled_slots
      
    end

    # INTERNALS

    def self.default_data
      warn("Capacitable uses array references instead of static attributes. You will need to define table values manually in your migrations.")
      return {}
    end

    def init_capacitable(access_method, args = {}, &block)
      if !Adjective.configuration.use_active_record
        max_slots = args[:max_slots] || 20
        baseline_weight = args[:baseline_weight] || 0
        define_capacitable_instance_variables({ 
          collection_ref: access_method,
          max_slots: max_slots,
          baseline_weight: baseline_weight
        })
        yield(self) if block_given?
      end      
    end   

    def define_capacitable_instance_variables(args)
      args.each do |key, value|
        self.class.send(:attr_accessor, key)
        self.instance_variable_set("@#{key.to_s}", value)
      end 
    end   

    def capacitable_strategies
      Adjective.registered_procs[:capacitable]
    end 

  end
end