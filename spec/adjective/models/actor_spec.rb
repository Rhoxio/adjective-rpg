RSpec.describe Adjective do
  # Can't descrive the class here because it's dynamically defined.

  before(:each) do 
    Adjective.configure do |config|
      config.use_active_record = true
    end    

    Adjective.build_class_definitions  
  end

  describe "initilization" do 

  end

end