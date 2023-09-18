module Adjective
  module Capacitable

    # TODO: Resolve position collisions if they exist. Take the deepest element
    # and just stick it in the next available nil shot. If no nil slot, throw an error
    # 
    # Get procs working again
    # Set up utilities for pulling index values, maybe a proc or just a standard method?
    # Add AR support - strict table declarations with correctly passed accessor method

    def collection_origin
      self.public_send(collection_ref)
    end

    def build_simple_collection!
      pulled = self.public_send(collection_ref)

      slot_count = infinite ? pulled.length + 1 : max_slots
      filled_array = Array.new(slot_count, nil)
      
      pulled.each_with_index do |item, index|
        position = item.respond_to?(:position) ? item.position : index
        # Have to stack after construction and replace duplicates with nils
        filled_array[position] = slot_struct.new(item, position, 1)
      end 

      self.collection = filled_array

      stack_items! if stacked
      collection
    end

    def stack_items!
      unique_objects = collection.compact.map{|entry| entry.item}.uniq
      unique_objects.each do |obj|

        applicable_indexes = []
        targeted_structs = collection.select.with_index do |struct, index| 
          next if struct.nil?
          found = struct.item == obj
          applicable_indexes.push(index) if found
          found
        end

        count = 0
        targeted_structs.each do |struct|
          count += 1 if struct.stack_size.nil? 
          count += struct.stack_size if struct.stack_size
        end

        # Need to select the right struct and set the stack_size for the set now..
        target_index = nil
        main_stack = collection.find.with_index do |struct, index|
          next if struct.nil?
          found = struct.item == obj
          target_index = index if found
          found
        end

        main_stack.stack_size = count unless obj.nil?
        main_stack.position = target_index

        applicable_indexes.delete(target_index)
        applicable_indexes.each {|idx| collection[idx] = nil }
      end

      return collection
    end

    def active_record_collection
      # going to require some method call expectations and assumed attributes
    end

    def slot_struct
      Struct.new(:item, :position, :stack_size)
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
      has_room = remaining_space - items.length >= 0

      if has_room
        items.each do |item|
          collection_origin << item
          nil_index = collection.index(nil)
          struct = slot_struct.new(item, nil_index, 1)
          collection[nil_index] = struct
          if infinite
            collection << nil unless collection.include?(nil)
          end
        end
      else
        raise ArgumentError, "Provided array exceeds max_slots if applied. remaining_space: #{remaining_space}, provided array length: #{items.length}"
      end
      build_simple_collection!
    end

    def move(target_index, destination_index)
      target = collection[target_index]
      destination = collection[destination_index]

      collection[destination_index] = target
      collection[destination_index].position = destination_index unless collection[destination_index].nil?

      collection[target_index] = destination
      collection[target_index].position = target_index unless collection[target_index].nil?
      return collection
    end

    def space_used
      collection.compact.map {|item| item.stack_size }.inject(:+)
    end

    def has_space?
      return true if infinite
      return space_used < max_slots  
    end

    def remaining_space
      return Float::INFINITY if infinite
      max_slots - space_used
    end

    def filled_slots
      collection.map.with_index do |struct, index|
        next if struct.nil?
        index
      end.compact
    end

    def empty_slots
      collection.map.with_index do |struct, index|
        next unless struct.nil?
        index
      end.compact
    end

    # INTERNALS

    def self.default_data
      warn("Capacitable uses array references instead of static attributes. You will need to define table values manually in your migrations.")
      return {}
    end

    def init_capacitable(access_method, args = {}, &block)
      if !Adjective.configuration.use_active_record
        define_capacitable_instance_variables({
          infinite: args[:infinite] || false,
          collection_ref: access_method,
          max_slots: args[:max_slots] || 20,
          baseline_weight: args[:baseline_weight] || 0,
          stacked: args[:stacked] || false
        })
      end

      self.class.send(:attr_accessor, :collection)
      self.instance_variable_set("@collection", Array.new(self.max_slots, nil))     

      self.build_simple_collection!

      yield(self) if block_given?      
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