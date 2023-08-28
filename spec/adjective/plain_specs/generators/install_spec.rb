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
    FileManager.truncate_files(file_dummy_root)
  end

  it "will create the Thorfile and config file" do 
    output = `thor adjective:setup --config_path #{file_dummy_config_path} --thorfile_path spec/file_dummy`
    expect(File.exist?(File.join(file_dummy_initializers_path, "adjective.rb"))).to eq(true)
    expect(File.exist?(File.join(file_dummy_root, "Thorfile"))).to eq(true)
  end

end