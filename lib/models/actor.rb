require_relative "application_record"
require 'awesome_print'

module Adjective

  module DefineActor
    def self.construct
      Adjective.send(:remove_const, "Actor") if Adjective.const_defined?("Actor")
      if Adjective.configuration.use_active_record
        actor = Class.new(ApplicationRecord) {self.table_name = "actors"}
        Adjective.const_set("Actor", actor)
      else
        actor = Class.new(Object)
        Adjective.const_set("Actor", actor)
      end
      self.eval_actor
      return actor
    end

    def self.eval_actor

      # Actor Class with No AR
      # This is set up so we can have functionality outside of linkages, essentially.
      if !Adjective.configuration.use_active_record
        Adjective::Actor.class_eval do 
          def initialize(args = {})
            @name = args[:name] ||= nil

            self.class.send(:attr_accessor, :name)
            self.class.send(:attr_accessor, :hitpoints)
          end
        end
      end

      # Base Actor Class
      Adjective::Actor.class_eval do 


        def shared_method
          true
        end
      end
    end 
  end
end