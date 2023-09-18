require 'securerandom'

RSpec.describe Adjective::Capacitable do

  let(:bag){
    Bag.new
  }

  let(:rock){
    Item.new("Rock", SecureRandom.hex(4), "environment_object")
  }

  let(:letter){
    Item.new("Letter", SecureRandom.hex(4), "readable_object") 
  }

  before(:each) do 
    bag.storage = [rock, letter]
    bag.build_simple_collection!
  end

  describe "initialization" do 
    it "will define expected defaults" do 
      expect(bag.max_slots).to eq(20)
      expect(bag.baseline_weight).to eq(0)
    end

    # it "will define #replace_all" do 
    #   expect(bag.replace_all!([1,2])).to eq([1,2])
    # end

    it "will allow for max_slots option to be passed" do 
      bag.init_capacitable(:storage, {max_slots: 10})
      expect(bag.max_slots).to eq(10)
    end

    it "will allow for baseline_weight to be set" do 
      # Basically if they want the bag to weigh something.
      bag.init_capacitable(:storage, {baseline_weight: 1})
      expect(bag.baseline_weight).to eq(1)
    end

    it "will accept a block" do 
      bag.init_capacitable(:storage) do |b|
        expect(b).to eq(bag)
        b.max_slots = 25
        b.baseline_weight = 1
      end

      expect(bag.max_slots).to eq(25)
      expect(bag.baseline_weight).to eq(1)
    end
  end

  describe "storage slots" do 
    it "will detect if storage has slots open or is full" do 
      bag.init_capacitable(:storage)
      expect(bag.has_space?).to eq(true)
      18.times { bag.store(rock) }
      expect(bag.has_space?).to eq(false)
    end

    it "will always detect an #infinite bag as not full" do 
      bag.init_capacitable(:storage, {infinite: true})
      expect(bag.has_space?).to eq(true)
      100.times { bag.store(rock) }
      expect(bag.has_space?).to eq(true)
    end

    it "will correctly count with the :stacked option on" do 
      bag.init_capacitable(:storage, {stacked: true})
      expect(bag.has_space?).to eq(true)
      18.times { bag.store(rock) }
      expect(bag.has_space?).to eq(false)
    end

    it "will calculate the #space_used" do 
      bag.init_capacitable(:storage)
      expect(bag.space_used).to eq(2)
    end

    it "will calculate the #space_used with :stacked on" do 
      bag.init_capacitable(:storage, {stacked: true})
      expect(bag.space_used).to eq(2)
    end    

    it "will calculate the #remaining_space" do 
      10.times do 
        bag.store(rock)
      end      
      expect(bag.remaining_space).to eq(8)
    end

    it "will give back infinity from #remaining_space if :infinte option is present" do 
      bag.init_capacitable(:storage, {infinite: true})
      expect(bag.remaining_space).to eq(Float::INFINITY)
    end

  end

  describe "storing" do 
    it "will #store items" do 
      bag.store(rock)
      bag.store(letter)
      expect(bag.storage.length).to eq(4)
      expect(bag.collection.compact.length).to eq(4)
    end

    it "will store items and restack" do 
      bag.init_capacitable(:storage, {stacked: true})
      bag.store(rock)
      bag.store(letter)
      expect(bag.storage.length).to eq(4)
      expect(bag.collection.compact.length).to eq(2)
      expect(bag.collection.find{|struct| struct.item.name == "Rock"}.stack_size).to eq(2)
      expect(bag.collection.find{|struct| struct.item.name == "Letter"}.stack_size).to eq(2)

      expect(bag.collection.find{|struct| struct.item.name == "Rock"}.position).to eq(0)
      expect(bag.collection.find{|struct| struct.item.name == "Letter"}.position).to eq(1)
    end

    it "will store more than one item at a time" do 
      bag.store([rock, letter, rock, rock])
      expect(bag.collection.compact.length).to eq(6)

      bag.init_capacitable(:storage, {stacked: true})
      bag.store([rock, letter, rock, rock])
      expect(bag.collection.find{|struct| struct.item.name == "Rock"}.stack_size).to eq(7)
      expect(bag.collection.find{|struct| struct.item.name == "Letter"}.stack_size).to eq(3)
    end

    context "infinite" do 
      it "will construct the correcly length of collection if given :infinite option" do 
        bag.init_capacitable(:storage, {infinite: true})
        expect(bag.storage.length).to eq(2)
        expect(bag.collection.length).to eq(3)
        expect(bag.collection.last).to eq(nil)
      end

      it "will correctly alter the collection after storing items" do 
        bag.init_capacitable(:storage, {infinite: true})
        rocks = []
        20.times do 
          rocks.push(rock)
        end
        bag.store(rocks)
        expect(bag.collection.last).to eq(nil)
        expect(bag.collection.length).to eq(23)
        expect(bag.storage.length).to eq(22)
      end

      it "will aceept stacked and infinite options" do 
        bag.init_capacitable(:storage, {infinite: true, stacked: true})
        rocks = []
        20.times do 
          rocks.push(rock)
        end        
        bag.store(rocks)
        expect(bag.collection.find{|struct| struct.item.name == "Rock"}.stack_size).to eq(21)
        expect(bag.collection.find{|struct| struct.item.name == "Letter"}.stack_size).to eq(1)
      end
    end


  end

  describe "serialization" do 

    before(:each) do 
      10.times do 
        bag.storage << rock
      end  

      3.times do 
        bag.storage << letter
      end 
    end

    context "stacking" do 

      it "will stack items based on total occurences" do 
        bag.init_capacitable(:storage, {stacked: true})
        expect(bag.collection[0].stack_size).to eq(11)
        expect(bag.collection[1].stack_size).to eq(4)
      end

      it "will not stack items unless #stack_items! is set" do 
        bag.init_capacitable(:storage, {stacked: false})
        expect(bag.collection.find{|struct| struct.item.name == "Rock"}.stack_size).to eq(1)
        expect(bag.collection.find{|struct| struct.item.name == "Letter"}.stack_size).to eq(1)
      end
    end

    it "will sandbox for me" do 
      
      # ap bag.stack_items!
    end
  end

  # describe "querying" do 

  #   context "utility strategies" do 
  #     it "will accept the default #find_one proc" do 
  #       expect(bag.query({
  #         strategy: :find_one, 
  #         ref: :name, 
  #         term: "Rock"
  #       })).to eq(rock)
  #     end   

  #     it "#find_one will return nil if nothing is found" do 
  #       response = bag.query({
  #         strategy: :find_one, 
  #         ref: :name, 
  #         term: "Bunk"
  #       })
  #       expect(response.nil?).to eq(true)
  #     end

  #     it "will #sort_by" do 
  #       bag.storage << Item.new("Almanac", SecureRandom.hex(2), "readable_object")
  #       sorted = bag.query({ 
  #         strategy: :sort_by, 
  #         ref: :name
  #       })
  #       expect(sorted.first.name).to eq("Almanac")
  #       expect(sorted.last.name).to eq("Rock")
  #     end

  #     it "will #find_all" do 
  #       bag.storage << rock
  #       expect(bag.query({
  #         strategy: :find_all, 
  #         ref: :name, 
  #         term: "Rock"
  #       }).length).to eq(2)
  #     end

  #     it "#find_all returns empty if no matches are found" do 
  #       response = bag.query({
  #         strategy: :find_all, 
  #         ref: :name, 
  #         term: "Bunk"
  #       })
  #       expect(response.empty?).to eq(true)
  #     end

  #     it "will #remove_by" do 
  #       bag.storage << rock
  #       expect(bag.storage.length).to eq(3)
  #       expect(bag.query({
  #         strategy: :remove_by, 
  #         ref: :name, 
  #         term: "Rock"
  #       })[0].name).to eq("Rock")
  #       expect(bag.query({strategy: :find_one, ref: :name, term: "Rock"})).to eq(nil)
  #       expect(bag.query({strategy: :find_all, ref: :name, term: "Letter"}).length).to eq(1)
  #     end

  #     it "#remove_by will return empty if nothing was removed" do 
  #       response = bag.query({
  #         strategy: :remove_by, 
  #         ref: :name, 
  #         term: "Bunk"
  #       })
  #       expect(response.empty?).to eq(true)
  #     end

  #     it "will #remove_one" do 
  #       bag.storage << rock
  #       expect(bag.storage.length).to eq(3)
  #       response = bag.query({
  #         strategy: :remove_one, 
  #         ref: :name, 
  #         term: "Rock"
  #       })
  #       expect(response.name).to eq("Rock")
  #       expect(bag.query({strategy: :find_one, ref: :name, term: "Rock"}).name).to eq("Rock")       
  #       expect(bag.query({strategy: :find_all, ref: :name, term: "Rock"}).length).to eq(1)
  #     end

  #     it "#remove_one will return nil if nothing was removed" do 
  #       response = bag.query({
  #         strategy: :remove_one, 
  #         ref: :name, 
  #         term: "Bunk"
  #       })    
  #       expect(response.nil?).to eq(true)    
  #     end
  #   end

  #   it "will accept a custom proc" do 
  #     custom_proc = Proc.new do |target, args|
  #       collection = target.collection
  #       expect(collection).to eq(bag.storage)
  #       expect(args[:ref]).to eq(:name)
  #       expect(args[:term]).to eq("Rock")
  #       [1,2,3]
  #     end

  #     expect(bag.query({
  #       custom_strategy: custom_proc, 
  #       ref: :name, 
  #       term: "Rock"
  #     })).to eq([1,2,3])

  #   end

  # end

end