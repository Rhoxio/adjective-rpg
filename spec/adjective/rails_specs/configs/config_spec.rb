RSpec.describe Adjective::Configuration do
  it "will load the correct defaults" do 
    expect(Adjective.configuration.use_active_record).to eq(true)
    expect(Adjective.configuration.root).to eq(Rails.root)
    expect(Adjective.configuration.config_file_path).to eq(File.join(Rails.root, 'config/initializers/adjective.rb'))
    expect(Adjective.configuration.migration_path).to eq(File.join(Rails.root, 'db/migrate'))
    expect(Adjective.configuration.models_path).to eq(File.join(Rails.root, 'app/models'))
  end
end