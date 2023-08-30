RSpec.describe Adjective do

  describe Adjective::CreateAdjectiveClass do
    it "will sandbox" do 
      template = Adjective::CreateAdjectiveClass.new("Enemy", ["vulnerable", "imbibable"])
      # ap template
    end

    it "will generate the correct class name" do 
      template = Adjective::CreateAdjectiveClass.new("enemy", ["vulnerable", "imbibable"])
      expect(template.file_class_name).to eq("Enemy")
    end

    it "will generate the correct file name" do 
      template = Adjective::CreateAdjectiveClass.new("enemy", ["vulnerable", "imbibable"])
      expect(template.file_name).to eq("enemy.rb")
    end

    it "will generate the correcy modules string" do 
      template = Adjective::CreateAdjectiveClass.new("enemy", ["vulnerable", "imbibable"])
      chunks = template.modules_string.split("\n")
      expect(chunks[0].lstrip).to eq("include Adjective::Vulnerable")
      expect(chunks[1].lstrip).to eq("include Adjective::Imbibable")
    end

    it "will return the correct inherited_classes per config context" do 
      template = Adjective::CreateAdjectiveClass.new("enemy", ["vulnerable", "imbibable"])
      expect(template.inherited_classes).to eq("< ApplicationRecord")

      Adjective.configure {|config| config.use_active_record = false}
      template = Adjective::CreateAdjectiveClass.new("enemy", ["vulnerable", "imbibable"])
      expect(template.inherited_classes).to eq("")

      Adjective.configure {|config| config.use_active_record = true}
    end

    it "will render the class correctly" do 
      template = Adjective::CreateAdjectiveClass.new("enemy", ["vulnerable", "imbibable"])
      chunks = template.render.split("\n")
      pieces = ["class Enemy < ApplicationRecord", "include Adjective::Vulnerable", "include Adjective::Imbibable", "end"]
      chunks.each do |chunk|
        expect(pieces.include?(chunk.lstrip)).to eq(true)
      end
    end
  end
end