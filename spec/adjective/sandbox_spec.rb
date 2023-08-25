require "rails_helper"

RSpec.describe Adjective do

  it "will actually load the rails env" do 
    expect(defined?(Rails)).to eq("constant")
  end

  it "will set up the correct default load path for Rails models" do 
    expect(Adjective.configuration.models_path). to eq("/Users/maze/Desktop/adjective-rpg/spec/dummy/app/models")
  end

  describe Adjective::Generators::SetupGenerator do
    before :all do
      remove_config
    end

    it 'installs config file properly' do
      described_class.start
      expect(File.file?(config_file)).to be true
    end
  end

  describe Adjective do 

    it "will see Adjective modules loaded before new is called" do 
      expect(Toon.included_modules.include?(Adjective::Vulnerable)).to eq(true)
    end

    it "will load the class without ActiveRecord" do 
      character = Character.new
      expect(Character.included_modules.include?(Adjective::Vulnerable)).to eq(true)
      expect(character.hitpoints).to eq(1)
      expect(character.max_hitpoints).to eq(10)
    end
  end


end