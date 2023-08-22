RSpec.describe Adjective::Vulnerable do

  before(:each) do 
    Adjective.build_class_definitions
    Adjective::Actor.class_eval do 
      include Adjective::Vulnerable
    end    
  end

  describe "initilization" do

    context "without AR" do 
      before(:each) do 
        Adjective.configure do |config|
          config.use_active_record = false
        end
      end

      it "will define instance variables on the included class" do 
        actor = Adjective::Actor.new
        actor.init_vulnerable
        expect(actor.hitpoints).to eq(1)
        expect(actor.max_hitpoints).to eq(10)
      end
    end

    context "with AR" do 
      before(:each) do 
        Adjective.configure do |config|
          config.use_active_record = true
        end
      end

      it "will still be able to pull attributes correctly" do
        actor = Adjective::Actor.new
        actor.init_vulnerable
        expect(actor.hitpoints).to eq(1)
        expect(actor.max_hitpoints).to eq(10)
      end

      it "will save attributes" do
        # This is wrong. Need to set up the tables first.


        # actor = Adjective::Actor.new
        # actor.init_vulnerable
        # expect(actor.hitpoints).to eq(1)

        # actor.hitpoints = 5
        # expect(actor.hitpoints).to eq(5)

        # ap actor.save!
        # actor.reload

        # expect(actor.hitpoints).to eq(5)

      end

    end

  end
end