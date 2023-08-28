RSpec.describe Adjective do

  let(:file_dummy_root){
    File.join(Dir.pwd, "spec/file_dummy")
  }

  let(:file_dummy_initializers_path){
    File.join(file_dummy_root, "/configs/initializers")
  }

  let(:file_dummy_config_path){
    "spec/file_dummy/configs/initializers/"
  }

  let(:file_dummy_thorfile_path){
    "spec/file_dummy/"
  }

  before(:each) do 
    FileManager.truncate_files(File.join(file_dummy_root, "/configs/initializers"))
    FileManager.truncate_files(File.join(file_dummy_root))
    FileManager.truncate_files(File.join(file_dummy_root, 'custom'))
  end

  it "will create the Thorfile and config file" do 
    output = `rake adjective:install -- config_path=#{file_dummy_config_path} thorfile_path=#{file_dummy_thorfile_path}`
    expect(File.exist?(File.join(file_dummy_initializers_path, "adjective.rb"))).to eq(true)
    expect(File.exist?(File.join(file_dummy_root, "Thorfile"))).to eq(true)
  end

  it "will allow for the Thorfile to be put in any dir" do 
    output = `rake adjective:install -- thorfile_path=#{File.join(file_dummy_thorfile_path, "custom")}`
    expect(File.exist?(File.join(file_dummy_root, "custom", "Thorfile"))).to eq(true)
  end
end