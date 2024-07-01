class Actor
  include Adjective::Vulnerable

  def initialize
    @hitpoints = Adjective::Hitpoints.new
  end
end