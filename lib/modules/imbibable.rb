module Adjective
  module Imbibable

    # Remember that 'level' access is index-based. level - 1 gives current level,
    # level gives the next level.

    # Need to set up a util to see exp thresholds at a given level
    # Shouls also probably set a module-level override for :constrain
    # and :suppress_level_up values as an option. 

    def max_level?
      max_level <= level
    end

    def max_level
      experience_table.length
    end

    def set_experience_to_level_minimum!
      constrain_experience
    end

    def level_up?
      return false if max_level?
      total_experience >= experience_table[level]
    end

    def level_up!
      until !level_up?
        self.level += 1
      end
    end    

    def set_level(num, opts = {})
      self.level = num
      constrain_experience unless opts[:constrain]
    end

    def grant_levels(num, opts = {})
      self.level += num
      self.level = max_level if self.level > max_level
      constrain_experience unless opts[:constrain] 
    end    

    def constrain_experience
      self.total_experience = experience_table[level - 1]
    end 

    def normalize_experience
      self.total_experience = 0 if total_experience < 0
    end

    def experience_to_next_level
      return nil if max_level?
      return experience_table[level] - total_experience
    end  

    def grant_experience(num, opts = {})
      return 0 if max_level?
      self.total_experience += num
      level_up! unless opts[:suppress_level_up]
      return total_experience
    end   

    # INTERNALS
    
    def init_imbibable(args = {}, &block)
      if !Adjective.configuration.use_active_record
        define_imbibable_instance_variables(Adjective::Imbibable.default_data)
      end

      @experience_table = args[:experience_table] || Adjective.experience_table
      self.class.send(:attr_accessor, :experience_table)

      if defined?(Rails) && Adjective.configuration.use_rails
        self.class.send(:alias_attribute, :experience, :total_experience)
      else
        self.class.send(:alias_method, :experience, :total_experience)
        self.class.send(:alias_method, :experience=, :total_experience=)
      end

      yield(self) if block_given?
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
    # include Adjective::IvarSettable    
  end
end