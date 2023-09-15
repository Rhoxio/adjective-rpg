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
  end

  describe "initialization" do 
    it "will define #access" do 
      expect(bag.collection).to eq(bag.storage)
    end

    it "will define #replace_all" do 
      expect(bag.replace_all!([1,2])).to eq([1,2])
    end
  end

  describe "querying" do 

    context "utility strategies" do 
      it "will accept the default #find_one proc" do 
        expect(bag.query({
          strategy: :find_one, 
          ref: :name, 
          term: "Rock"
        })).to eq(rock)
      end   

      it "#find_one will return nil if nothing is found" do 
        response = bag.query({
          strategy: :find_one, 
          ref: :name, 
          term: "Bunk"
        })
        expect(response.nil?).to eq(true)
      end

      it "will #sort_by" do 
        bag.storage << Item.new("Almanac", SecureRandom.hex(2), "readable_object")
        sorted = bag.query({ 
          strategy: :sort_by, 
          ref: :name
        })
        expect(sorted.first.name).to eq("Almanac")
        expect(sorted.last.name).to eq("Rock")
      end

      it "will #find_all" do 
        bag.storage << rock
        expect(bag.query({
          strategy: :find_all, 
          ref: :name, 
          term: "Rock"
        }).length).to eq(2)
      end

      it "#find_all returns empty if no matches are found" do 
        response = bag.query({
          strategy: :find_all, 
          ref: :name, 
          term: "Bunk"
        })
        expect(response.empty?).to eq(true)
      end

      it "will #remove_by" do 
        bag.storage << rock
        expect(bag.storage.length).to eq(3)
        expect(bag.query({
          strategy: :remove_by, 
          ref: :name, 
          term: "Rock"
        })[0].name).to eq("Rock")
        expect(bag.query({strategy: :find_one, ref: :name, term: "Rock"})).to eq(nil)
        expect(bag.query({strategy: :find_all, ref: :name, term: "Letter"}).length).to eq(1)
      end

      it "#remove_by will return empty if nothing was removed" do 
        response = bag.query({
          strategy: :remove_by, 
          ref: :name, 
          term: "Bunk"
        })
        expect(response.empty?).to eq(true)
      end

      it "will #remove_one" do 
        bag.storage << rock
        expect(bag.storage.length).to eq(3)
        response = bag.query({
          strategy: :remove_one, 
          ref: :name, 
          term: "Rock"
        })
        expect(response.name).to eq("Rock")
        expect(bag.query({strategy: :find_one, ref: :name, term: "Rock"}).name).to eq("Rock")       
        expect(bag.query({strategy: :find_all, ref: :name, term: "Rock"}).length).to eq(1)
      end

      it "#remove_one will return nil if nothing was removed" do 
        response = bag.query({
          strategy: :remove_one, 
          ref: :name, 
          term: "Bunk"
        })    
        expect(response.nil?).to eq(true)    
      end
    end

    it "will accept a custom proc" do 
      custom_proc = Proc.new do |target, args|
        collection = target.collection
        expect(collection).to eq(bag.storage)
        expect(args[:ref]).to eq(:name)
        expect(args[:term]).to eq("Rock")
        [1,2,3]
      end

      expect(bag.query({
        custom_strategy: custom_proc, 
        ref: :name, 
        term: "Rock"
      })).to eq([1,2,3])

    end

  end

end