class Item
  attr_accessor :name, :id, :item_type

  def initialize(name, id, item_type = "")
    @name = name
    @id = id
    @item_type = item_type
  end
end