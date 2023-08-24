RSpec.describe Adjective::MigrationRenderer do



  before(:each) do 
    Adjective.configure do |config|
      config.set_config_file_path("config/adjective.yml")
      config.use_active_record = true
    end    

    Adjective.build_class_definitions 
  end

  it "sandboxes" do 
    renderer = Adjective::MigrationRenderer.new
    renderer.render
  end

  it "sandboxes inheritance" do 
    class Creature < Adjective::Actor
      def anything
        true
      end
    end

    ap creature = Creature.new
  end

end