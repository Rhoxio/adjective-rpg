# require 'securerandom'

# RSpec.describe Adjective::Capacitable do

#   let(:bag){
#     Bag.new
#   }

#   let(:rock){
#     Item.new("Rock", SecureRandom.hex(4), "environment_object")
#   }

#   let(:letter){
#     Item.new("Letter", SecureRandom.hex(4), "readable_object") 
#   }

#   before(:each) do 
#     bag.storage = [rock, letter]
#   end

#   describe "initialization" do 
#     it "will define #access" do 
#       expect(bag.access).to eq(bag.storage)
#     end

#     it "will define #replace_all" do 
#       expect(bag.replace_all!([1,2])).to eq([1,2])
#     end
#   end

#   describe "querying" do 
#     context "utility strategies" do 
#       it "will accept the default #find_one proc" do 
#         expect(bag.query(:name, "Rock")).to eq(rock)
#         # ap bag.query(:name, "Rock", Adjective::Capacitable.find_all)
#       end   

#       it "will #find_all" do 
#         bag.storage << rock
#         expect(bag.query(:name, "Rock", Adjective::Capacitable.find_all).length).to eq(2)
#       end   

#       it "will #sort_by" do 
#         query_module = Adjective::Capacitable
#         query = query_module.sort_by
#         ap query
#         bag.storage << Item.new("Almanac", SecureRandom.hex(2), "readable_object")
#         ap bag.query(:name, query)
#       end
#     end

#     it "will accept a custom proc" do 
#       custom_proc = Proc.new do |collection, accessor, value|
#         expect(collection).to eq(bag.storage)
#         expect(accessor).to eq(:name)
#         expect(value).to eq("Rock")
#         [1,2,3]
#       end
#       expect(bag.query(:name, "Rock", custom_proc)).to eq([1,2,3])
#     end

#   end

# end