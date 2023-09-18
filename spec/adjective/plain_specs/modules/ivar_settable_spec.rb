# RSpec.describe Adjective::IvarSettable do
#   class Surrogate
#     include Adjective::Imbibable

#     def initialize
#       init_imbibable
#     end
#   end

#   after(:each) do 
#     Adjective.configure do |config|
#       config.use_active_record = true
#     end
#   end

#   it "Imbibable will respond to the #adjective_columns module method" do 
#     # expect(Adjective::Imbibable.respond_to?(:test_pls))
#     ap "---------"
#     ap Adjective::Imbibable.define_module_ivars
#     ap Adjective::Imbibable.define_imbibable_instance_variables({})
#     Adjective.configure do |config|
#       config.use_active_record = false
#     end
#     # ap Adjective.configuration.use_active_record

#     s = Surrogate.new
#     # s.init_imbibable
#     # ap s
    
#     # ap s.instance_variables
#   end

#   # it "will generate the correct singleton method" do 
#   #   Adjective::Imbibable.define_module_ivars
#   #   expect(Adjective::Imbibable.respond_to?(:define_imbibable_instance_variables)).to eq(true)
#   # end
# end