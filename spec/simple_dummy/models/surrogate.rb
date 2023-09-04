require_relative "../adjective"
class Surrogate
  include Adjective::Imbibable

  def initialize
    init_imbibable
  end
end