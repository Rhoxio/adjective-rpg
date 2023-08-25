# require 'generators/adjective/setup_generator'

RSpec.describe Adjective do

  it "will actually load the rails env" do 
    ap Adjective.configuration
  end

  describe Adjective::Generators::SetupGenerator do
    before :all do
      remove_config
    end

    it 'installs config file properly' do
      described_class.start
      expect(File.file?(config_file)).to be true
    end
  end


end