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

  describe "class construction" do 
    context "with active use_active_record enabled" do 
      before(:each) do 
        Adjective.configure do |config|
          config.use_active_record = true
        end
      end    

      it "will create the Actor class" do 
        Adjective.build_class_definitions
        expect(Adjective::Actor.new.class.name).to eq("Adjective::Actor")
      end

      it "will inherit from ActiveRecord" do 
        Adjective.build_class_definitions
        expect(Adjective::Actor.new.class.superclass).to eq(ApplicationRecord)
      end

      it "will include id column" do 
        Adjective.build_class_definitions
        actor = Adjective::Actor.new
        expect(actor.id).to eq(nil)
      end

      it "will respond to a shared method" do 
        expect(Adjective::Actor.new.respond_to?(:shared_method)).to eq(true)
      end       

    end

    context "without use_active_record enabled" do 
      before(:each) do 
        Adjective.configure do |config|
          config.use_active_record = false
        end
        Adjective.build_class_definitions
      end

      it "will create the Actor class" do 
        expect(Adjective::Actor.new.class.name).to eq("Adjective::Actor")
      end

      it "will not inherit from ActiveRecord" do 
        expect(Adjective::Actor.new.class.superclass).to eq(Object)
      end  

      it "has getters and setters as defined in the initializer" do 
        expect(Adjective::Actor.new.respond_to?(:name)).to eq(true)
        expect(Adjective::Actor.new.respond_to?(:name=)).to eq(true)
      end  

      it "will respond to a shared method" do 
        expect(Adjective::Actor.new.respond_to?(:shared_method)).to eq(true)
      end  

    end

  end


end
