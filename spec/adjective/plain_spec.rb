require "plain_helper"

RSpec.describe Adjective do
  # Need to set this up to allow me to use ActiveRecord once I get generators in, too.

  it "will let me access the scoped class" do 
    char = PlainDummy::Character.new
  end
end