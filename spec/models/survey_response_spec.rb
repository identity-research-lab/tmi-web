require 'rails_helper'

RSpec.describe SurveyResponse do

  context "#from" do
    
    let(:record) {
      { 
        "ResponseId" => "1234567890",
        "age_given" => "21",
        "pronouns_given" => "self-describe",
        "pronouns_given_5_TEXT" => "example pronoun"
      }
    }
    
    before do
      SurveyResponse.from(record)
    end
    
    it 'creates from a record' do
      expect(SurveyResponse.count).to eq(1)
    end
    
  end
  
end
