class Item < ApplicationRecord
  has_many :bag_items
  has_many :bags, through: :bag_items
end