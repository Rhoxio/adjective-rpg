class BagItem < ApplicationRecord
  belongs_to :bag
  belongs_to :item
end