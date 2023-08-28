RSpec.describe Adjective do

  let(:file_dummy_root){
    File.join(Dir.pwd, "spec/file_dummy")
  }

  let(:file_dummy_initializers_path){
    File.join(file_dummy_root, "/config/initializers")
  }

  let(:file_dummy_config_path){
    "spec/file_dummy/config/initializers/"
  }

  before(:each) do 
    FileManager.truncate_files(File.join(file_dummy_root, "/config/initializers"))
  end

  it "will create the config file" do 
    output = `thor adjective:setup --config_path #{file_dummy_config_path}`
    expect(File.exist?(File.join(file_dummy_initializers_path, "adjective.rb"))).to eq(true)
  end

end