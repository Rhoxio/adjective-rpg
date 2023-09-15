module Adjective
  module CapacitableProcs
    def self.all
      {
        find_one: self.find_one,
        find_all: self.find_all,
        sort_by: self.sort_by,
        remove_by: self.remove_by,
        remove_one: self.remove_one
      }         
    end

    def self.find_one
      Proc.new do |target, args|
        collection = target.collection
        collection.find do |item|
          item.public_send(args[:ref]) == args[:term]
        end
      end    
    end

    def self.find_all
      Proc.new do |target, args|
        collection = target.collection
        collection.select do |item|
          item.public_send(args[:ref]) == args[:term]
        end
      end
    end

    def self.sort_by
      Proc.new do |target, args|
        collection = target.collection
        collection.sort_by { |item| item.public_send(args[:ref]) }
      end
    end

    def self.remove_by
      Proc.new do |target, args|
        collection = target.collection
        removed = self.find_all.call(target, args)
        remaining = collection.reject do |item|
          item.public_send(args[:ref]) == args[:term]
        end
        target.replace_all!(remaining)
        removed
      end
    end

    def self.remove_one
      Proc.new do |target, args|
        collection = target.collection
        removed = nil
        removed_index = collection.find_index { |item| item.public_send(args[:ref]) == args[:term] }
        removed = collection.delete_at(removed_index) if removed_index
        target.replace_all!(collection) if removed
        removed
      end
    end

  end
end