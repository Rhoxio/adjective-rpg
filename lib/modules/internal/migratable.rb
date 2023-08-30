module Adjective
  module Migratable
    def self.included(base)
      base.extend(ModuleMethods)
    end

    module ModuleMethods
      def adjective_columns
        columns = self.default_data.map do |key, value|
          "t.#{value.class.to_s.downcase} :#{key.to_s}"
        end
        columns.unshift("# #{self.to_s} attributes")
      end  

      def adjective_add_columns(klass)
        columns = self.default_data.map do |key, value|
          "add_column :#{klass.downcase}, :#{key.to_s}, :#{value.class.to_s.downcase}"
        end 
        columns.unshift("# #{self.to_s} Attributes")
      end
    end

    extend ModuleMethods
  end
end