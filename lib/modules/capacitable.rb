module Adjective
  module Capacitable

    def init_capacitable(access_method, args = {}, &block)

      define_capacitable_instance_variables({
        infinite: args[:infinite] || false,
        collection_ref: access_method,
        max_slots: args[:max_slots] || 20,
        baseline_weight: args[:baseline_weight] || 0,
        stacked: args[:stacked] || false
      })
      
      set_internal_variables

      self.build_collection!

      yield(self) if block_given?      
    end    

    def collection_origin
      self.public_send(collection_ref)
    end

    def build_collection!
      pulled = self.public_send(collection_ref)

      slot_count = infinite ? pulled.length + 1 : max_slots
      filled_array = Array.new(slot_count, nil)
      
      pulled.each_with_index do |item, index|
        position = item.respond_to?(:position) ? item.position : index
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

        count = targeted_structs.sum { |struct| struct.stack_size || 1 }
        main_stack = find_by_item(obj)
        exempted_indexes = [main_stack&.position]

        targeted_structs.each do |struct|
          if struct.stack_size > 1
            exempted_indexes << struct.position 
            count -= struct.stack_size unless struct.position == main_stack&.position
          end
        end

        applicable_indexes.delete_if {|el| exempted_indexes.include?(el)}

        main_stack.stack_size = count unless obj.nil?
        main_stack.position = main_stack&.position
        applicable_indexes.each { |idx| collection[idx] = nil }
      end

      return collection
    end

    def restack!
      # TODO
    end

    def find_by_item(object)
      collection.find do |struct|
        next if struct.nil?
        struct.item == object
      end      
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
      stack_items! if stacked
      return collection
    end

    def extract(target_indexes)
      indexes = Array(target_indexes)
      selected = collection.select do |struct|
        next if struct.nil?
        indexes.include?(struct.position)
      end

      indexes.each {|idx| collection[idx] = nil}
      return selected.map{|struct| struct.item}
    end

    def move(target_index:, destination_index:)
      target = collection[target_index]
      destination = collection[destination_index]

      if (target&.item == destination&.item) && stacked
        return combine_stacks(target_index: target_index, destination_index: destination_index)
      end

      collection[destination_index] = target
      collection[destination_index].position = destination_index unless collection[destination_index].nil?

      collection[target_index] = destination
      collection[target_index].position = target_index unless collection[target_index].nil?
      return collection
    end

    def split_stack(target_index:, destination_index:, amount:)
      target = collection[target_index]
      destination = collection[destination_index]

      return false if target.nil?
      return false unless destination.nil?
      return false unless target.stack_size > amount

      collection[target_index].stack_size -= amount
      new_stack = slot_struct.new(target.item, destination_index, amount)
      collection[destination_index] = new_stack
      return collection
    end

    def combine_stacks(target_index:, destination_index:)
      target = collection[target_index]
      destination = collection[destination_index]
      return false if (target.nil? || destination.nil?)

      destination.stack_size += target.stack_size
      collection[target_index] = nil
      return destination
    end

    def space_used
      collection.compact.map {|item| item.stack_size }.inject(:+) || 0
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

    def capacitable_strategies
      Adjective.registered_procs[:capacitable]
    end 

    private

    def define_capacitable_instance_variables(args)
      args.each do |key, value|
        self.class.send(:attr_accessor, key)
        self.instance_variable_set("@#{key.to_s}", value)
      end 
    end 

    def set_internal_variables
      self.class.send(:attr_accessor, :collection)
      self.instance_variable_set("@collection", Array.new(self.max_slots, nil))      
    end         

  end
end