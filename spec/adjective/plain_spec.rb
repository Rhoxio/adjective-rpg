require "plain_helper"

RSpec.describe Adjective do
  # Need to set this up to allow me to use ActiveRecord once I get generators in, too.

  it "will let me access the scoped class" do 
    char = PlainDummy::Character.new
  end

  it "will load Adjective lib configs" do 
    expect(Adjective.configuration.use_active_record).to eq(false)
  end

  it "will set the config_file_path to the dir where the initializer is" do 
    expect(Adjective.configuration.config_file_path).to eq("/Users/maze/Desktop/adjective-rpg/spec/plain_dummy/adjective.rb")
  end

  describe Adjective::AddColumnsMigration do 
    it "will load class_name correctly" do 
      template = Adjective::AddColumnsMigration.new("Character", ["vulnerable"])
      expect(template.class_name).to eq("Character")
    end

    it "will initially format the module names to lowercase" do 
      template = Adjective::AddColumnsMigration.new("Character", ["VUlNErABLE"])
      expect(template.modules.include?("vulnerable")).to eq(true)      
    end

    it "will load modules correctly" do 
      template = Adjective::AddColumnsMigration.new("Character", ["vulnerable"])
      expect(template.module_classes.include?(Adjective::Vulnerable)).to eq(true)
    end

    it "will generate the migration class correctly" do 
      template = Adjective::AddColumnsMigration.new("Character", ["vulnerable", "imbibable"])
      expect(template.generate_migration_class).to eq("AddVulnerableAndImbibableToCharacter")
    end

    it "will create the migration name correctly" do 
      template = Adjective::AddColumnsMigration.new("Character", ["vulnerable", "imbibable"])
      file_name_chunks = template.generate_file_name.split("_")
      # Could check for timestamp, but I think it's consistent enough to be fine.
      expect(file_name_chunks[1]).to eq("add")
      expect(file_name_chunks[2]).to eq("vulnerable")
      expect(file_name_chunks[3]).to eq("and")
      expect(file_name_chunks[4]).to eq("imbibable")
      expect(file_name_chunks[5]).to eq("to")
      expect(file_name_chunks[6]).to eq("character.rb")
    end

    it "will pull the right column definitions" do 
      template = Adjective::AddColumnsMigration.new("Character", ["vulnerable", "imbibable"])
      chunks = template.generate_attribute_fields.split("\n")
      ap chunks
      # Leaving the comment line out.
      expect(chunks[1].lstrip).to eq("add_column :character, :hitpoints, :integer")
      expect(chunks[2].lstrip).to eq("add_column :character, :max_hitpoints, :integer")

      expect(chunks[5].lstrip).to eq("add_column :character, :total_experience, :integer")
      expect(chunks[6].lstrip).to eq("add_column :character, :level, :integer")
    end

    it "will render the correct migration string" do 
      template = Adjective::AddColumnsMigration.new("Character", ["vulnerable", "imbibable"])
      chunks = template.render.split("\n")
      ap chunks
      expect(chunks[0]).to eq("class AddVulnerableAndImbibableToCharacter < ActiveRecord::Migration[7.0]")
      expect(chunks[1].lstrip).to eq("def up")
      expect(chunks[3].lstrip).to eq("add_column :character, :hitpoints, :integer")
      expect(chunks[4].lstrip).to eq("add_column :character, :max_hitpoints, :integer")
      expect(chunks[7].lstrip).to eq("add_column :character, :total_experience, :integer")
      expect(chunks[8].lstrip).to eq("add_column :character, :level, :integer")
      expect(chunks[10].lstrip).to eq("end")
    end
  end  
end








