module Adjective
  module IvarSettable
    def self.included(base)
      base.extend(ModuleMethods)
    end

    module ModuleMethods
      def define_module_ivars
        module_name = self.to_s.split("::").last.downcase
        define_singleton_method :"define_#{module_name}_instance_variables" do |args|
          args.each do |key, value|
            self.class.send(:attr_accessor, key)
            self.instance_variable_set("@#{key.to_s}", value)
          end           
        end
      end
    end

    extend ModuleMethods
  end
end