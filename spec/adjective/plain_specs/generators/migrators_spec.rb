RSpec.describe Adjective do

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
      expect(template.migration_class).to eq("AddVulnerableAndImbibableToCharacter")
    end

    it "will create the migration name correctly" do 
      template = Adjective::AddColumnsMigration.new("Character", ["vulnerable", "imbibable"])
      file_name_chunks = template.file_name.split("_")
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
      chunks = template.attribute_up_fields.split("\n")
      # ap chunks
      # Leaving the comment line out.
      expect(chunks[1].lstrip).to eq("add_column :character, :hitpoints, :integer")
      expect(chunks[2].lstrip).to eq("add_column :character, :max_hitpoints, :integer")

      expect(chunks[5].lstrip).to eq("add_column :character, :total_experience, :integer")
      expect(chunks[6].lstrip).to eq("add_column :character, :level, :integer")
    end

    it "will render the correct migration string" do 
      template = Adjective::AddColumnsMigration.new("Character", ["vulnerable", "imbibable"])
      chunks = template.render.split("\n")
      # ap chunks
      expect(chunks[0]).to eq("class AddVulnerableAndImbibableToCharacter < ActiveRecord::Migration[7.0]")
      expect(chunks[1].lstrip).to eq("def up")
      expect(chunks[3].lstrip).to eq("add_column :character, :hitpoints, :integer")
      expect(chunks[4].lstrip).to eq("add_column :character, :max_hitpoints, :integer")
      expect(chunks[7].lstrip).to eq("add_column :character, :total_experience, :integer")
      expect(chunks[8].lstrip).to eq("add_column :character, :level, :integer")
      expect(chunks[9].lstrip).to eq("end")
    end
  end  

  describe Adjective::CreateTableMigration do  
    it "will sandbox" do 
      template = Adjective::CreateTableMigration.new("Enemy", ["vulnerable", "imbibable"])
      expect(template.class_name).to eq("Enemy")
      expect(template.modules).to eq(["vulnerable", "imbibable"])
      expect(template.module_classes).to eq([Adjective::Vulnerable, Adjective::Imbibable])
    end

    it "will generate the correct class name" do 
      template = Adjective::CreateTableMigration.new("Enemy", ["vulnerable", "imbibable"])
      expect(template.migration_class).to eq("CreateEnemyWithVulnerableAndImbibable")
    end

    it "will generate the correct migration file name" do 
      template = Adjective::CreateTableMigration.new("Enemy", ["vulnerable", "imbibable"])
      file_name_chunks = template.file_name.split("_")
      # Could check for timestamp, but I think it's consistent enough to be fine.
      expect(file_name_chunks[1]).to eq("create")
      expect(file_name_chunks[2]).to eq("enemy")
      expect(file_name_chunks[3]).to eq("with")
      expect(file_name_chunks[4]).to eq("vulnerable")
      expect(file_name_chunks[5]).to eq("and")
      expect(file_name_chunks[6]).to eq("imbibable.rb")
    end

    it "will create the correct column definitions" do 
      template = Adjective::CreateTableMigration.new("Enemy", ["vulnerable", "imbibable"])
      chunks = template.columns.split("\n")
      # ap chunks
      expect(chunks[1].lstrip).to eq("t.integer :hitpoints")
      expect(chunks[2].lstrip).to eq("t.integer :max_hitpoints")
      expect(chunks[5].lstrip).to eq("t.integer :total_experience")
      expect(chunks[6].lstrip).to eq("t.integer :level")
    end

    it "will render the migration class correctly" do 
      template = Adjective::CreateTableMigration.new("EnemyDog", ["vulnerable", "imbibable"])
      chunks = template.render.split("\n")
      # ap chunks
      expect(chunks[0]).to eq("class CreateEnemyDogWithVulnerableAndImbibable < ActiveRecord::Migration[7.0]")
      expect(chunks[1].lstrip).to eq("def change")
      expect(chunks[2].lstrip).to eq("create_table :enemy_dog do |t|")
      expect(chunks[10].lstrip).to eq("end")
      expect(chunks[11].lstrip).to eq("end")
      expect(chunks[12].lstrip).to eq("end")
    end
  end
end








