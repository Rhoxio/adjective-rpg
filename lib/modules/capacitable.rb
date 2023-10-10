module Adjective
  module Capacitable

    # Get procs working again

    # restack! functionality. should restack all identity items in structs
    # restack_item(obj), restacks a certain item signature
    # review return values - some of them seem a little jank as defaults
    # Add AR support - strict table declarations with correctly passed accessor method

    # Resolve position collisions if they exist with AR models. Take the deepest element
    # and just stick it in the next available nil shot. If no nil slot, throw an error
    # Technically, this needs to work outside of Ar if they load from
    # a text file or something, but I think having it follow AR object definitions is better.
    # Punting until I get AR examples and figure out how I want the data in.

    # Ok, so I need to set it up so the struct gets initialized 1:1 if the join table is
    # present. If there's no join table/reference present, build from defaults (as it is now).
    # I think I just need a different method for it. It doesnt feel clean sticking it all into 
    # conditional statement hell there

    # I have a feeling that the auto-load issue is more of an object
    # instatiation thing. I think it needs to go into an included block?

    # I think defining the AR callbacks in the included block makes sense?
    # I could have them define methods instead of passing opts... I guess?
    # This does make more sense. They have open options to define specific return values
    # and can assign things directly if the need arises. As long as the method exists and returns
    # the right value, it does make sense to do it this way versus having it be a static opts def...
    # This even means that they can set up tables in thair db to help with this if they want to.
    # This does make more sense, but it feels awkward. I guess it's just a matter of seeing if I can get
    # it working correctly.

    # Ok, now theres an issue with init_cap not being called. It doesn't know what defaults to use.
    # This can be easily solved with a singleton method on the superclass that defines the data it needs.
    # It should all be static anyway I think...

    # I think the config method strategy is actaully way better - not gonna lie.
    # The only caveat will be that any code called in it will need to be done AFTER init
    # no matter what for the AR cases.

    def self.included(base)

      if Adjective.configuration.use_active_record
        base.class_eval do 
          after_initialize do
            build_collection!
          end  

          after_find do
            build_collection!
          end

          after_update do
            build_collection!
          end  

          after_create do
            build_collection!
          end 
        end
      end
    end

    def collection_origin
      self.public_send(collection_ref)
    end

    def build_simple_collection!
      # Meant to be an in-memory version - no AR hookups.
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

    def validate_active_record_dependency_methods
      if !self.respond_to?(:capacitable_settings)
        raise ArgumentError, "No #capacitable_settings method defined on model. Please define it and provide a :collection_access_method, :item_accessor, and :item_collection as hash keys in the return value."
      end

      if !self.capacitable_settings.key?(:collection_access_method)
        raise ArgumentError, "Please provide a :collection_access_method key to the #capacitable_settings method to enable ActiveRecord auto-syncing. 
        This is the getter method for the relationship that maps how items are saved in this inventory. 
        e.g. :bag_items method (join relationship) on a Bag model that links to the things to be stored."
      end  

      if !self.capacitable_settings.key?(:item_collection)
        raise ArgumentError, "Please provide a :item_collection to the #capacitable_settings method to enable ActiveRecord auto-syncing.
        This is an accessor method for the items on the model.
        e.g. Bag has_many Items through BagItems, so :items would be correct."
      end
      
      if !self.capacitable_settings.key?(:item_accessor)
        raise ArgumentError, "Please provide a :item_accessor to the #capacitable_settings method to enable ActiveRecord auto-syncing.
        This is an accessor method for the item in the relationship modeling. 
        e.g. Bag has_many Items through BagItems, so :item would be correct."
      end

    end

    def build_collection!
      # AR version of the build and serialization.
      validate_active_record_dependency_methods
      settings = self.capacitable_settings

      define_capacitable_instance_variables({
        infinite: settings[:infinite] || false,
        collection_ref: settings[:collection_access_method],
        max_slots: settings[:max_slots] || 20,
        baseline_weight: settings[:baseline_weight] || 0,
        stacked: settings[:stacked] || false,
        item_accessor: settings[:item_accessor] || :item,
        item_collection: settings[:item_collection] || :items,
      })
      set_internal_variables

      pulled = self.public_send(@collection_ref)
      slot_count = infinite ? pulled.length + 1 : max_slots
      filled_array = Array.new(slot_count, nil)

      pulled.each_with_index do |data, index|
        position = (data.respond_to?(:position) && !data&.position.nil?) ? data.position : index
        filled_array[position] = slot_struct.new(data.public_send(@item_accessor), position, 1)
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
        # I feel like an error should be thrown here if the position is nil instead of 
        # safe-operator checking it. If I don't, the last step can mess it all up and
        # set a nil position which isn't an expectation anywhere except for on
        # the initial build... and even then it's not a default. It comes from a reliable
        # source... the indexes of the array or the position itself. It's not guarnanteed to
        # be correct coming out of their db though...
        # I guess this makes sense as a check
        # against tampering on the collection from the outside?
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
        applicable_indexes.each {|idx| collection[idx] = nil }
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

    def set_internal_variables
      self.class.send(:attr_accessor, :collection)
      self.instance_variable_set("@collection", Array.new(self.max_slots, nil))      
    end

    def init_capacitable(access_method, args = {}, &block)

      define_capacitable_instance_variables({
        infinite: args[:infinite] || false,
        collection_ref: access_method,
        max_slots: args[:max_slots] || 20,
        baseline_weight: args[:baseline_weight] || 0,
        stacked: args[:stacked] || false
      })
      
      set_internal_variables
     
      if Adjective.configuration.use_active_record
        self.build_collection!
      else
        self.build_simple_collection!  
      end

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