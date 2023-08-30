RSpec.describe Adjective::Configuration do
  it "will load Adjective lib configs" do 
    expect(Adjective.configuration.use_active_record).to eq(true)
    expect(Adjective.configuration.root).to eq("/Users/maze/Desktop/adjective-rpg/spec/plain_dummy/")
  end

  it "will set the config_file_path to the dir where the initializer is" do 
    expect(Adjective.configuration.config_file_path).to eq("/Users/maze/Desktop/adjective-rpg/spec/plain_dummy/adjective.rb")
  end
end