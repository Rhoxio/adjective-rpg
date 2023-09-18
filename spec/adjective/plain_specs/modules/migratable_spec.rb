RSpec.describe Adjective::Migratable do
  it "Imbibable will respond to the #adjective_columns module method" do 
    expect(Adjective::Imbibable.respond_to?(:adjective_columns))
  end

  it "Imbibable will respond to the #adjective_add_columns module method" do 
    expect(Adjective::Imbibable.respond_to?(:adjective_add_columns))
  end
end