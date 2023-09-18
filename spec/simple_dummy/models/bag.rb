class Bag
  attr_accessor :storage
  include Adjective::Capacitable

  def initialize
    @storage = []
    init_capacitable(:storage)
  end
end