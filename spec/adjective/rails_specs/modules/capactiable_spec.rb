RSpec.describe Adjective::Capacitable do

  describe "sandbox" do 
    it "will sandbox for me rw" do
      # new_bag = Bag.new 
      # ap new_bag.methods
      # bag = Bag.create(name: "Satchel")
      # item = Item.create(name: "Rock", description: "Just a rock")

      # bag.items << item
      # bag.items << item
      # bag.items << item
      # bag.items << item
      # bag.items << item
      # bag.reload
      # bag.save!

      # ap "calling bag.collection"
      # ap bag.collection

      # ap bag.join_source

    end
  end

  describe "mutations" do 

    context "default bag settings" do 

      before(:each) do 
        @bag = Bag.create(name: "Satchel")
        @rock = Item.create(name: "Rock", description: "Just a rock")
        @stick = Item.create(name: "Stick", description: "A stick")

        @bag.store(@rock)
        @bag.store(@stick)
        @bag.save!        
      end    
        
      it "will allow for items to be added" do 
        @rock.reload
        @stick.reload
        expect(@rock.bags.first).to eq(@bag)
        expect(@stick.bags.first).to eq(@bag)

        expect(@bag.find_by_item(@rock).item.name).to eq(@rock.name)
        expect(@bag.find_by_item(@stick).position).to eq(1)
      end

      it "will allow items to be extracted" do 
        ap @bag.collection
        ap @stick
        ap @rock
        ap @bag.bag_items
        taken = @bag.extract(0)
        expect(taken[0].name).to eq('Rock')
        @bag.save!

        ap @bag.collection

      end

    end

  end
end