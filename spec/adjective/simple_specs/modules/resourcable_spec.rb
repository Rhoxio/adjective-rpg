RSpec.describe Adjective::Resourcable do

  let(:mana){
    Mana.new
  }

  describe "initialization" do 
    it "will define the correct getters/setters" do 
      expect(mana.respond_to?(:current_value)).to eq(true)
      expect(mana.respond_to?(:max_value)).to eq(true)
      expect(mana.respond_to?(:min_value)).to eq(true)
    end

    it "will set the correct default values" do 
      expect(mana.current_value).to eq(0)
      expect(mana.min_value).to eq(0)
      expect(mana.max_value).to eq(100)
    end

    it "defines the correct aliases" do 
      expect(mana.current_value).to eq(mana.value)
      expect(mana.max_value).to eq(mana.maximum)
      expect(mana.min_value).to eq(mana.minimum)
    end
  end

  describe "methods" do 
    context "percentages" do 
      it "#percent_remaining will return the correct integer" do 
        mana.current_value = 50
        expect(mana.percent_remaining).to eq(50)
      end

      it "#percent_remaining gives back an exact float if options is passed" do 
        mana.current_value = 26
        mana.max_value = 120
        expect(mana.percent_remaining({exact: true})).to eq(21.666666666666668)
      end

      it "#percent_to_full returns the correct integer" do 
        mana.current_value = 40
        expect(mana.percent_to_full).to eq(60)
      end

      it "#percent_to_full returns the correct float" do 
        mana.current_value = 26
        mana.max_value = 120
        expect(mana.percent_to_full({exact: true})).to eq(78.33333333333333)
      end 
    end

    context "bounds" do 
      it "will detect if values are #in_bounds?" do 
        mana.current_value = 100
        mana.max_value = 100
        expect(mana.in_bounds?).to eq(true)

        mana.current_value = 101
        expect(mana.in_bounds?).to eq(false)

        mana.current_value = -1
        expect(mana.in_bounds?).to eq(false)

        mana.min_value = -5
        expect(mana.in_bounds?).to eq(true)
      end

      it "will detect an #underflowed?" do 
        mana.current_value = -1
        mana.min_value = 0
        expect(mana.underflowed?).to eq(true)
      end

      it "will detect an #overflowed?" do
        mana.min_value = 0 
        mana.current_value = 101
        mana.max_value = 100
        expect(mana.overflowed?).to eq(true)
      end      
    end

    context "normalization" do 
      it "will correctly normalize" do 
        mana.current_value = 101
        mana.max_value = 100
        mana.min_value = 0

        mana.normalize!
        expect(mana.current_value).to eq(100)

        mana.current_value = -1
        mana.normalize!
        expect(mana.current_value).to eq(0)
      end
    end

    context "mathematical operations" do 
      it "will check if #full?" do 
        mana.max_value = 100
        mana.current_value = 100
        expect(mana.full?).to eq(true)
      end

      it "will check if #empty?" do 
        mana.max_value = 100
        mana.current_value = 0
        expect(mana.empty?).to eq(true)
      end      

      it "will calculate #missing" do 
        mana.current_value = 50
        mana.max_value = 100
        mana.min_value = 0

        expect(mana.missing).to eq(50)      
      end

      it "will correctly add by default" do 
        mana.current_value = 10
        mana.adjust(20)
        expect(mana.current_value).to eq(30)       
      end

      it "will ignore max_value if overflow is passed" do 
        mana.current_value = 100
        mana.adjust(10, {overflow: true})
        expect(mana.current_value).to eq(110)
      end

      it "will ignore min_value if underflow is passed" do 
        mana.current_value = 0
        mana.adjust(-10, {underflow: true})
        expect(mana.current_value).to eq(-10)
      end   

      it "will normalize if bounds are exceeded" do 
        mana.current_value = 100
        mana.adjust(20)
        expect(mana.current_value).to eq(100)         
      end  

      it "will #subtract correctly" do 
        mana.current_value = 100
        mana.subtract(20)
        expect(mana.current_value).to eq(80)
      end

      it "aliases #adjust to #add" do 
        mana.current_value = 10
        mana.add(20)  
        expect(mana.current_value).to eq(30)        
      end 

      it "will #percent_adjust" do 
        mana.current_value = 0
        mana.max_value = 116
        mana.min_value = 0

        mana.adjust_percent(10)
        expect(mana.value).to eq(12)
      end

      it "will #percent_subtract" do 
        mana.current_value = 116
        mana.max_value = 116
        mana.min_value = 0

        mana.subtract_percent(10)
        expect(mana.value).to eq(104)
      end
    end
   
  end

  describe "doc examples" do 
    class ManaUser
      attr_accessor :mana
      
      include Adjective::Imbibable

      def initialize
        @mana = Mana.new
        init_imbibable
      end
    end

    let(:mana_user){
      ManaUser.new
    }

    it "wont freak out with the new character class" do 
      expect(mana_user.mana.is_a?(Mana)).to eq(true)
    end

    it "will show basic mana values" do 
      expect(mana_user.mana.value).to eq(0)
    end

    it "gives me the rightpercentage for the add/subtract one" do 
      mana_user.mana.value = 10
      mana_user.mana.maximum = 200
      expect(mana_user.mana.add_percent(15)).to eq(23)
    end


  end

end








