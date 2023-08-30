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
      chunks = template.file_name.split("_").map{|c| c.lstrip }
      # Could check for timestamp, but I think it's consistent enough to be fine.
      expected_chunks = [
        "add",
        "vulnerable",
        "and",
        "imbibable",
        "to",
        "character.rb"
      ]
      expected_chunks.each do |line|
        expect(chunks.include?(line)).to eq(true)
      end 
    end

    it "will pull the right column definitions" do 
      template = Adjective::AddColumnsMigration.new("Character", ["vulnerable", "imbibable"])
      chunks = template.attribute_up_fields.split("\n").map{|c| c.lstrip }

      expected_lines = [
        "add_column :character, :hitpoints, :integer",
        "add_column :character, :max_hitpoints, :integer",
        "add_column :character, :total_experience, :integer",
        "add_column :character, :level, :integer"
      ]
      expected_lines.each do |line|
        expect(chunks.include?(line)).to eq(true)
      end          
    end

    it "will render the correct migration string" do 
      template = Adjective::AddColumnsMigration.new("Character", ["vulnerable", "imbibable"])
      chunks = template.render.split("\n").map{|c| c.lstrip }

      expected_lines = [
        "class AddVulnerableAndImbibableToCharacter < ActiveRecord::Migration[7.0]",
        "def up",
        "add_column :character, :hitpoints, :integer",
        "add_column :character, :max_hitpoints, :integer",
        "add_column :character, :total_experience, :integer",
        "add_column :character, :level, :integer",
        "end"
      ]
      expected_lines.each do |line|
        expect(chunks.include?(line)).to eq(true)
      end      
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
      chunks = template.columns.split("\n").map{|c| c.lstrip }
      expected_columns = ["t.integer :hitpoints", "t.integer :max_hitpoints", "t.integer :total_experience", "t.integer :level"]
      expected_columns.each do |column|
        expect(chunks.include?(column)).to eq(true)
      end
    end

    it "will render the migration class correctly" do 
      template = Adjective::CreateTableMigration.new("EnemyDog", ["vulnerable", "imbibable"])
      chunks = template.render.split("\n").map{|c| c.lstrip }
      expect(chunks.select{ |c| c.lstrip == "end" }.length).to eq(3)
      expected_chunks = [
        "class CreateEnemyDogWithVulnerableAndImbibable < ActiveRecord::Migration[7.0]",
        "  def change",
        "    create_table :enemy_dog do |t|",
        "      # Adjective::Vulnerable attributes",
        "      t.integer :hitpoints",
        "      t.integer :max_hitpoints",
        "      # Adjective::Imbibable attributes",
        "      t.integer :level",
        "      t.integer :total_experience",
        "    end",
        "  end",
        "end"
      ].map {|l| l.lstrip}

      expected_chunks.each do |column|
        expect(chunks.include?(column)).to eq(true)
      end
    end
  end
end








