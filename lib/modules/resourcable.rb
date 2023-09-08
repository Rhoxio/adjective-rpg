module Adjective
  module Resourcable

    def percent_remaining(opts = {})
      exact = opts[:exact] || false
      percentage = ((current_value.to_f / max_value.to_f) * 100)
      return percentage if opts[:exact]
      return percentage.round
    end

    def percent_to_full(opts = {})
      exact = opts[:exact] || false
      diff = max_value - current_value
      percentage = ((diff.to_f / max_value.to_f) * 100)
      return percentage if opts[:exact]
      return percentage.round
    end

    def missing
      max_value - current_value
    end

    def in_bounds?
      (!underflowed?) && (!overflowed?)
    end

    def underflowed?
      min_value > current_value
    end

    def overflowed?
      current_value > max_value
    end

    def adjust(value, opts = {})
      overflow = opts[:overflow] || false
      underflow = opts[:underflow] || false
      self.current_value += value
      normalize_min! if overflow
      normalize_max! if underflow
      normalize! unless (overflow || underflow)
      return current_value
    end

    # Not the cleanest/dryest, but otherwise I have to do some funky 
    # symbol passing stuff and Ruby method chaining.
    # This works and is relatively simple. 
    def subtract(value, opts = {})
      overflow = opts[:overflow] || false
      underflow = opts[:underflow] || false
      self.current_value -= value
      normalize_min! if overflow
      normalize_max! if underflow
      normalize! unless (overflow || underflow)
      return current_value
    end 

    # Percent operations optimistically round to maintain integer status.
    # Can always add a high_precision or float option later if needed and
    # make it return the value versus setting it.
    def adjust_percent(value, opts = {})
      total = (max_value.to_f / value.to_f).round
      adjust(total, opts)
    end

    def subtract_percent(value, opts = {})
      total = (max_value.to_f / value.to_f).round
      subtract(total, opts)
    end       

    def normalize!
      normalize_max!
      normalize_min!
      return current_value
    end

    def normalize_max!
      self.current_value = max_value if overflowed?
    end

    def normalize_min!
      self.current_value = min_value if underflowed?
    end

    # INTERNALS

    def init_resourcable(args = {}, &block)
      if !Adjective.configuration.use_active_record
        define_resourcable_instance_variables(Adjective::Resourcable.default_data)
      end

      self.class.send(:alias_method, :add, :adjust)
      self.class.send(:alias_method, :add_percent, :adjust_percent)

      if defined?(Rails) && Adjective.configuration.use_rails
        self.class.send(:alias_attribute, :value, :current_value)
        self.class.send(:alias_attribute, :maximum, :max_value)
        self.class.send(:alias_attribute, :manimum, :min_value)        
      else
        self.class.send(:alias_method, :value, :current_value)
        self.class.send(:alias_method, :maximum, :max_value)
        self.class.send(:alias_method, :minimum, :min_value)
      end

      yield(self) if block_given?
    end

    def self.default_data
      {
        current_value: 0,
        max_value: 100,
        min_value: 0
      }
    end

    def define_resourcable_instance_variables(args)
      args.each do |key, value|
        self.class.send(:attr_accessor, key)
        self.instance_variable_set("@#{key.to_s}", value)
      end 
    end 

    include Adjective::Migratable    
  end
end