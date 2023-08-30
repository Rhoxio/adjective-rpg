RSpec.describe Adjective do
  let(:file_dummy_root){
    File.join(Dir.pwd, "spec/file_dummy")
  }

  let(:file_dummy_migrations_path){
    "db/migrate"
  }

  let(:file_dummy_models_path){
    "app/models"
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
    FileManager.truncate_files(File.join(file_dummy_root, file_dummy_models_path))
  end

  it "will generate a create table migration and model" do 
    output = `rake adjective:scaffold_for -- model=Character config_path=#{file_dummy_config_path} include=Vulnerable,Imbibable`
    Dir.entries(file_dummy_absolute_migrations_path).each do |filename|
      next if filename == '.' || filename == '..'
      expect(filename.split("_").drop(1).join("_")).to eq("create_character_with_vulnerable_and_imbibable.rb")
    end  
    expect(File.exists?(File.join(file_dummy_root, file_dummy_models_path, "character.rb"))).to eq(true)
  end
end