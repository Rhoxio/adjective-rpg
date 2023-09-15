module Adjective
  module CapacitableProcs
    def self.all
      {
        find_one: self.find_one,
        find_all: self.find_all,
        sort_by: self.sort_by
      }         
    end

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

    def self.sort_by
      Proc.new do |collection, accessor, term|
        collection.sort_by { |item| item.public_send(accessor) }
      end
    end

  end
end