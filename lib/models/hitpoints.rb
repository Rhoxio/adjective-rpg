module Adjective
  class Hitpoints
    include Adjective::Resourcable

    def initialize
      init_resourcable
    end
  end
end
