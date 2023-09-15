RSpec.describe Adjective::Callable do

  let(:find_one_proc){
    Proc.new do |collection, accessor, value|
      collection.find do |item|
        item.public_send(accessor) == value
      end
    end    
  }

  describe "setup" do 
    it "will set custom procs to namespaced values" do 
      Adjective.register_procs do |register|
        register.namespace(:global) do |namespace|
          namespace[:find_one] = find_one_proc
        end
      end

      expect(Adjective.registered_procs.key?(:global)).to eq(true)
      expect(Adjective.registered_procs[:global].key?(:find_one)).to eq(true)
      expect(Adjective.registered_procs[:global][:find_one]).to eq(find_one_proc)
    end

    it "will load default procs" do 
      expect(Adjective.registered_procs.key?(:capacitable)).to eq(true)
      expect(Adjective.registered_procs[:capacitable].key?(:find_one)).to eq(true)
    end

    it "will allow for procs to be used in Adjective-specific modules by default" do 
      
    end
  end


end