module Adjective
  class IncludedModels
    def initialize
      @models = nil
    end

    def find_included_models
      Dir[Rails.root.join('app', 'models', '**', '*.rb')].each do |file|
        require_dependency file
      end
      # model_path = Adjective.configuration.models_path
      ap ApplicationRecord.descendants
    end
  end
end