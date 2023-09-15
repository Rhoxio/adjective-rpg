module Adjective
  module CapacitableProcs
    def self.all
      {
        find_one: self.find_one,
        find_all: self.find_all,
        sort_by: self.sort_by,
        remove_by: self.remove_by
      }         
    end

    def self.find_one
      Proc.new do |target, args|
        collection = target.collection
        collection.find do |item|
          item.public_send(args[:accessor]) == args[:term]
        end
      end    
    end

    def self.find_all
      Proc.new do |target, args|
        collection = target.collection
        collection.select do |item|
          item.public_send(args[:accessor]) == args[:term]
        end
      end
    end

    def self.sort_by
      Proc.new do |target, args|
        collection = target.collection
        collection.sort_by { |item| item.public_send(args[:accessor]) }
      end
    end

    def self.remove_by
      Proc.new do |target, args|
        collection = target.collection
        remaining = collection.reject do |item|
          item.public_send(args[:accessor]) == args[:term]
        end
        target.replace_all!(remaining)
      end
    end

  end
end