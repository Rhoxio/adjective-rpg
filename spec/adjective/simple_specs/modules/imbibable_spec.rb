RSpec.describe Adjective::Imbibable do

  # Testing Defaults:
  # [0, 100, 200, 400, 800, 1600, 3200, 6400, 12800]

  let(:surrogate){
    Surrogate.new
  }

  describe "initialization" do 
    it "will gain methods" do 
      [:init_imbibable, :define_imbibable_instance_variables].each do |method|
        expect(surrogate.methods.include?(method)).to eq(true)
      end
    end

    it "will gain attributes" do 
      expect(surrogate.level).to eq(1)
      expect(surrogate.total_experience).to eq(0)
    end

    it "will accept a block on initialization" do 
      surrogate.init_imbibable do |surr|
        surr.level = 2
        surr.total_experience = 101
      end
      expect(surrogate.level).to eq(2)
      expect(surrogate.total_experience).to eq(101)
    end

    it "will allow for instance variables to be set and read" do 
      surrogate.level = 2
      surrogate.total_experience = 101
      expect(surrogate.level).to eq(2)
      expect(surrogate.total_experience).to eq(101)
    end   

    it "will allow for the experience_table to be set in block and through opts" do
      surrogate.init_imbibable({experience_table: [0, 200, 400, 800]})
      expect(surrogate.experience_table).to eq([0, 200, 400, 800])

      surrogate.init_imbibable do |surr|
        surr.experience_table = [1,2,3,4,5]
      end

      expect(surrogate.experience_table).to eq([1,2,3,4,5])
    end 

    it "will take the adjective default if no experience_table is provided" do 
      surrogate.init_imbibable
      expect(surrogate.experience_table).to eq([0, 100, 200, 400, 800, 1600, 3200, 6400, 12800])
    end

  end

  describe "aliases" do 
    it "will alias total_experience to experience" do 
      surrogate.total_experience = 100
      expect(surrogate.experience).to eq(100)

      surrogate.experience = 200
      expect(surrogate.total_experience).to eq(200)
    end

    it "will treat the data set in aliases as internal representations" do 
      surrogate.experience = 1000
      surrogate.level_up!
      expect(surrogate.level).to eq(5)
    end
  end

  describe "utilities" do 
    context "max" do 
      it "will return the max level possible" do 
        expect(surrogate.max_level).to eq(9)
        surrogate.experience_table = [1,2,3,4,5]
        expect(surrogate.max_level).to eq(5)
      end

      it "will check if they are max level" do 
        expect(surrogate.max_level?).to eq(false)
        surrogate.level = 9
        expect(surrogate.max_level?).to eq(true)
      end
    end

    context "setter utils" do 
      it "will #set_experience_to_level_minimum!" do 
        surrogate.total_experience = 900
        surrogate.level = 5
        surrogate.set_experience_to_level_minimum!
        expect(surrogate.total_experience).to eq(800)
      end
    end

    context "level management utils" do 
      it "#level_up? will check if they can level up" do 
        surrogate.total_experience = 900
        surrogate.level = 5

        expect(surrogate.level_up?).to eq(false)
        surrogate.total_experience = 1601
        expect(surrogate.level_up?).to eq(true)
      end

      it "#level_up? will return false if they are max level" do 
        surrogate.level = 9
        expect(surrogate.level_up?).to eq(false)
      end

      it "will level them up when #level_up! is called" do 
        surrogate.total_experience = 400
        surrogate.level_up!
        expect(surrogate.level).to eq(4)
      end

      it "will normalize_experience if they are below 0" do 
        surrogate.total_experience = -1
        surrogate.normalize_experience
        expect(surrogate.total_experience).to eq(0)
      end

      it "will calculate the #experience_to_next_level" do 
        surrogate.total_experience = 700
        surrogate.level_up!
        expect(surrogate.experience_to_next_level).to eq(100)
      end

      context "#set_level" do 
        it "will set their level" do 
          surrogate.total_experience = 500
          surrogate.level_up!
          surrogate.set_level(8)
          expect(surrogate.level).to eq(8)
          expect(surrogate.total_experience).to eq(6400)
        end

        it "will not update their exp if :constrain is passed" do 
          surrogate.total_experience = 500
          surrogate.level_up!
          surrogate.set_level(8, {constrain: true})
          expect(surrogate.level).to eq(8)
          expect(surrogate.total_experience).to eq(500)
        end
      end

      context "#grant_levels" do
        it "will grant them levels with #grant_levels" do 
          surrogate.grant_levels(2)
          expect(surrogate.level).to eq(3)
          expect(surrogate.total_experience).to eq(200)
        end

        it "will constrain exp gain with #grants_level" do 
          surrogate.grant_levels(2, {constrain: true})
          expect(surrogate.level).to eq(3)
          expect(surrogate.total_experience).to eq(0)
        end

        it "will not set the level above max_level" do 
          surrogate.grant_levels(99)
          expect(surrogate.level).to eq(9)
          expect(surrogate.total_experience).to eq(12800)
        end


      end

      context "#grant_experience" do 
        it "will grant experience" do 
          surrogate.grant_experience(99)
          expect(surrogate.total_experience).to eq(99)
        end

        it "will automatically level them up" do 
          surrogate.grant_experience(101)

          expect(surrogate.level).to eq(2)
        end

        it "will suppress_level_up if option is passed" do 
          surrogate.grant_experience(100, {suppress_level_up: true})
          expect(surrogate.total_experience).to eq(100)
          expect(surrogate.level).to eq(1)
        end

        it "will set to max_level" do 
          surrogate.grant_experience(12800)
          expect(surrogate.level).to eq(9)
        end
      end

      context "wiki examples" do 
        class Character
          include Adjective::Imbibable

          def initialize
            init_imbibable
          end
        end

        let(:character){
          Character.new
        }

        before(:each) do 
          Adjective.experience_table = [0, 100, 200, 400, 800, 1600, 3200, 6400, 12800]
        end

        it "level_up? example" do 
          character.experience = 100
          expect(character.level_up?).to eq(true)
        end

        it "level_up! example" do 
          character.experience = 100
          character.level_up!
          expect(character.level).to eq(2)
        end        

        it "grant_experience example" do 
          expect(character.total_experience).to eq(0)
          expect(character.level).to eq(1)

          character.grant_experience(100)

          expect(character.total_experience).to eq(100)
          expect(character.level).to eq(2)
        end

        it "experience_to_next_level example" do 
          character.grant_experience(95)
          expect(character.experience_to_next_level).to eq(5)
        end

        it "max_level example" do 
          character.grant_experience(12800)
          expect(character.level).to eq(9)
          expect(character.max_level?).to eq(true)
        end

        it "set_level example" do 
          expect(character.level).to eq(1)
          character.set_level(5)
          expect(character.level).to eq(5)
          expect(character.experience).to eq(800)

          # Can also pass :constrain to stop experience from being awarded
          expect(character.level).to eq(5)
          character.set_level(8, {constrain: true})
          expect(character.level).to eq(8)
          expect(character.experience).to eq(800)
        end

        it "grant_levels example" do 
          expect(character.level).to eq(1)
          character.grant_levels(4)
          expect(character.level).to eq(5)
          expect(character.experience).to eq(800)

          # Can also pass :constrain to stop experience from being awarded
          expect(character.level).to eq(5)
          character.grant_levels(3, {constrain: true})
          expect(character.level).to eq(8)
          expect(character.experience).to eq(800)
        end
      end


    end


  end

end