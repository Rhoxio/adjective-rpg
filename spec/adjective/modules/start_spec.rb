RSpec.describe 'startup' do
  it "will start with use_active_record set to false" do 
    expect(Adjective.configuration.use_active_record).to eq(false)
  end

  it "will load stuff in the models dir" do 
    surrogate = Surrogate.new
    expect(!!surrogate).to eq(true)
  end
end