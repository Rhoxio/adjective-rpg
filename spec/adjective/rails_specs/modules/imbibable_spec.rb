RSpec.describe Adjective::Imbibable do
  # This is a smaller set of tests jsut to ensure that Rails plays nicely with 
  # the defined module methods and potentially tricky pieces.

  let(:character){
    Character.new
  }

  before(:each) do 
    character.total_experience = 0
    character.level = 1
    character.max_hitpoints = 10
    character.hitpoints = 10
    character.save!
  end

  describe "initialization" do 
    it "will allow for base values to be set" do 
      expect(character.level).to eq(1)
      expect(character.total_experience).to eq(0)
    end

    it "will accept a block after initialization" do 
      character.init_imbibable do |c|
        c.total_experience = 101
        c.level = 2
      end
      expect(character.level).to eq(2)
      expect(character.total_experience).to eq(101)
    end

    it "will pull the default experience_table" do 
      expect(character.experience_table).to eq([0, 100, 200, 400, 800, 1600, 3200, 6400, 12800])
    end

    it "will allow for the experience_table to be set as an argument" do 
      character.init_imbibable({experience_table: [0, 200, 400, 800]})
      expect(character.experience_table).to eq([0, 200, 400, 800])
    end

    it "will allow for the experience_table to be set in the block" do 
      character.init_imbibable do |c|
        c.experience_table = [0, 200, 400, 800]
      end
      expect(character.experience_table).to eq([0, 200, 400, 800])
    end
  end

  describe "aliases" do 
    it "will alias total_experience to experience" do 
      expect(character.experience).to eq(character.total_experience)
    end

    it "will treat the data set in aliases as internal representations" do 
      character.experience = 1000

      character.level_up!
      expect(character.total_experience).to eq(1000)
      expect(character.level).to eq(5)

      character.save!
      character.reload
      expect(character.experience).to eq(1000)
    end
  end

end