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
      included_mixins = Adjective.configuration.mixins_for("actor").map{|mixin| "Adjective::#{mixin}".constantize}
      # Actor Class with No AR
      # This is set up so we can have functionality outside of linkages, essentially.
      if !Adjective.configuration.use_active_record
        Adjective::Actor.class_eval do 
          def initialize(args = {})
            @name = args[:name] ||= nil

            self.class.send(:attr_accessor, :name)
            yield(self) if block_given?
          end
        end
      end

      # Base Actor Class (with AR and without AR)
      Adjective::Actor.class_eval do 
        included_mixins.each {|mixin| include mixin}

        def shared_method
          true
        end

        def adjective_columns
          <<~RUBY
            # Actor Attributes
            t.string :name
          RUBY
        end


      end
    end 
  end
end