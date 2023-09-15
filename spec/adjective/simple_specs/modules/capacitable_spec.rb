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
          accessor: :name, 
          term: "Rock"
        })).to eq(rock)
      end   

      it "will #sort_by" do 
        bag.storage << Item.new("Almanac", SecureRandom.hex(2), "readable_object")
        sorted = bag.query({ 
          strategy: :sort_by, 
          accessor: :name
        })
        expect(sorted.first.name).to eq("Almanac")
        expect(sorted.last.name).to eq("Rock")
      end

      it "will #find_all" do 
        bag.storage << rock
        expect(bag.query({
          strategy: :find_all, 
          accessor: :name, 
          term: "Rock"
        }).length).to eq(2)
      end

      it "will #remove_by" do 
        bag.storage << rock
        expect(bag.storage.length).to eq(3)
        bag.query({
          strategy: :remove_by, 
          accessor: :name, 
          term: "Rock"
        })
        expect(bag.query({strategy: :find_one, accessor: :name, term: "Rock"})).to eq(nil)
        expect(bag.query({strategy: :find_all, accessor: :name, term: "Letter"}).length).to eq(1)
      end
    end

    it "will accept a custom proc" do 
      custom_proc = Proc.new do |target, args|
        collection = target.collection
        expect(collection).to eq(bag.storage)
        expect(args[:accessor]).to eq(:name)
        expect(args[:term]).to eq("Rock")
        [1,2,3]
      end

      expect(bag.query({
        custom_strategy: custom_proc, 
        accessor: :name, 
        term: "Rock"
      })).to eq([1,2,3])

    end

  end

end