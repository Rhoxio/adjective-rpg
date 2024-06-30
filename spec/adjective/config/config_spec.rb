RSpec.describe Adjective::Configuration do

  xit "will set the config_file_path to the dir where the initializer is" do
    expect(Adjective.configuration.config_file_path).to eq("/Users/maze/Desktop/adjective-rpg/spec/plain_dummy/adjective.rb")
  end

  xit "will take the defaults from the config file" do
    expect(Adjective.experience_table).to eq([0, 100, 200, 400, 800, 1600, 3200, 6400, 12800])
  end

  xit "will allow for a custom table to be defined" do
    Adjective.experience_table = [0,1,2,3]
    expect(Adjective.experience_table).to eq([0,1,2,3])
  end
end