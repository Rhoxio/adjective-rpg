module Adjective
  module Capacitable

    def collection
      self.public_send(collection_ref)
    end

    def replace_all!(array)
      self.public_send("#{collection_ref}=", array)
    end

    # Assuming they can just use their own select/detect...
    # I think i should really just pass self in here... no joke.
    # Having the specific delegation is just not right. It'll
    # know how to dymanically match based on the @access_method as it is. 
    def query(accessor, term = "", matcher = Adjective::Capacitable.find_one)
      matches = matcher.call(self)
      return matches
    end


    # INTERNALS

    def self.default_data
      warn("Capacitable uses array references instead of static attributes. You will need to define table values manually in your migrations.")
      return {}
    end

    def init_capacitable(access_method, args = {}, &block)
      if !Adjective.configuration.use_active_record
        define_capacitable_instance_variables({collection_ref: access_method})
      end      
      # @capacitable_access_method = access_method
    end   

    def define_capacitable_instance_variables(args)
      args.each do |key, value|
        self.class.send(:attr_accessor, key)
        self.instance_variable_set("@#{key.to_s}", value)
      end 
    end    

    # The proc should include their own iterators, I think. Otherwise, I am just limiting
    # the expressiveness af the code and limiting their own method access while producing
    # side-effects. 

    # Built-in Procs
    def self.find_one
      Proc.new do |collection, accessor, value|
        collection.find do |item|
          item.public_send(accessor) == value
        end
      end
    end

    def self.find_all
      Proc.new do |collection, accessor, value|
        collection.select do |item|
          item.public_send(accessor) == value
        end
      end
    end

    # Need to set up mutiple conditional matches an as example...
    def self.sort_by
      Proc.new do |collection, accessor, term|
        collection.sort_by { |item| item.public_send(accessor) }
      end
    end

  end
end