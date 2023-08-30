RSpec.describe Adjective do
  let(:file_dummy_root){
    File.join(Dir.pwd, "spec/file_dummy")
  }

  let(:file_dummy_migrations_path){
    "db/migrate"
  }

  let(:file_dummy_absolute_migrations_path){
    File.join(file_dummy_root, file_dummy_migrations_path)
  }

  # We need to have a static config file loaded to simulate adjective:install already being run and configured correctly.
  let(:file_dummy_config_path){
    "spec/file_dummy/static/adjective"
  }

  before(:each) do   
    FileManager.truncate_files(File.join(file_dummy_root, file_dummy_migrations_path))
  end

  it "will generate the add columns migration" do 
    output = `rake adjective:add_columns_for -- model=Character config_path=#{file_dummy_config_path} include=Vulnerable,Imbibable`
    Dir.entries(file_dummy_absolute_migrations_path).each do |filename|
      next if filename == '.' || filename == '..'
      expect(filename.split("_").drop(1).join("_")).to eq("add_vulnerable_and_imbibable_to_character.rb")
    end
  end

  # it "will complain if there is no include options provided" do 
    
  #   output = `rake adjective:add_columns_for -- model=Character config_path=#{file_dummy_config_path} include=`
  #   allow($STDIN).to receive(:gets){"n\n"}
  #   ap output
  # end
end