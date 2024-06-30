require_relative "../simple_dummy/adjective"
class Surrogate
  include Adjective::Imbibable

  def initialize
    init_imbibable
  end
end