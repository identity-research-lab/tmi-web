RSpec.describe "Keyword" do

  context "#from" do
  
    it "populates keywords from a survey response" do
      expect(klass: "Code").to.receive(:where).with(context: "age")
    end
  
  end
    
end
