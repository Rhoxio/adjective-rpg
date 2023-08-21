# frozen_string_literal: true

RSpec.describe Adjective do
  
  it "has a version number" do
    expect(Adjective::VERSION).not_to be nil
  end

  describe "configuration" do 
    before(:each) do 
      Adjective.configure do |config|
        config.use_active_record = false
      end
    end    

    it "use_active_record defaults to false" do
      Adjective.configure do |config|
        expect(config.use_active_record).to eq(false)
      end
    end

    it "use_active_record can be changed to true" do 
      Adjective.configure do |config|
        config.use_active_record = true
        expect(config.use_active_record).to eq(true)
      end
    end

    it "should give me access to the configuration" do 
      expect(Adjective.configuration.use_active_record).to eq(false)
    end

  end


end
