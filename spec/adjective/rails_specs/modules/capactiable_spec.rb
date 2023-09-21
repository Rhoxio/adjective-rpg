RSpec.describe Adjective::Capacitable do

  describe "sandbox" do 
    it "will sandbox for me rw" do 
      bag = Bag.create(name: "Satchel")
      item = Item.create(name: "Rock", description: "Just a rock")

      bag.items << item
      bag.items << item
      bag.items << item
      bag.items << item
      bag.items << item
      bag.reload
      bag.save!

      ap "calling bag.collection"
      ap bag.collection

      # ap bag.join_source

    end
  end
end