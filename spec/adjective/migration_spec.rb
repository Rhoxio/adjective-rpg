require 'rake'

RSpec.describe Adjective do

  let(:attributes){
    [
      :id,
      :name
    ]
  }
  before(:all) do 
    Adjective.configure do |config|
      config.use_active_record = false
    end
  end
  
  it "creates the actors table" do
    expect(ActiveRecord::Base.connection.table_exists?('actors')).to eq(true)
  end

  it "contains the expected columns" do 
    attributes.each do |attr|
      expect(ActiveRecord::Base.connection.column_exists?(:actors, attr)).to eq(true)
    end 
  end


end