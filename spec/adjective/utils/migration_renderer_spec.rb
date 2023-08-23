RSpec.describe Adjective::MigrationRenderer do

  before(:each) do 
    Adjective.configure do |config|
      config.use_active_record = true
    end    

    Adjective.build_class_definitions 
  end

  # it "sandboxes" do 
  #   renderer = Adjective::MigrationRenderer.new
  #   ap renderer.render
  # end

end