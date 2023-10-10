class Bag < ApplicationRecord
  has_many :bag_items
  has_many :items, through: :bag_items

  def data_ref
    :bag_items
  end

  def item_collection
    :items
  end

  def item_accessor
    :item
  end 

  def capacitable_settings
    {
      collection_access_method: :bag_items,
      item_collection: :items,
      item_accessor: :item
    }
  end

  include Adjective::Capacitable



end