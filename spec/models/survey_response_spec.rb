require 'rails_helper'

RSpec.describe SurveyResponse do

  context "#from" do
    
    let(:complete_record) {
      { 
        "ResponseId" => "123456",
        "age_given" => "21",
        "pronouns_given" => "self-describe",
        "pronouns_given_5_TEXT" => "example pronoun"
      }
    }
    
    let(:incomplete_record) {
      {
        "ResponseId" => "234567",
        "pronouns_given" => "she/her",
      }
    }
    
    before do
      SurveyResponse.from(complete_record)
      SurveyResponse.from(incomplete_record)
    end
    
    it 'creates from a valid record' do
      expect(SurveyResponse.find_by(response_id: complete_record['ResponseId'])).to_not be_nil
    end
    
    it 'handles self-described pronouns' do
      survey_response = SurveyResponse.find_by(response_id: complete_record['ResponseId'])
      expect(survey_response.pronouns_given).to eq("example pronoun (self-described)")
    end
    
    it 'does not create from an incomplete record' do
      expect(SurveyResponse.find_by(response_id: incomplete_record['ResponseId'])).to be_nil
    end
    
  end
  
  context "#identifier" do
  
    it "pads an ID lower than 10000"  do
      survey_response = SurveyResponse.new(id: 1)
      expect(survey_response.identifier).to eq("0001")
    end
    
    it "does not pad an ID higher than 9999"  do
      survey_response = SurveyResponse.new(id: 10123)
      expect(survey_response.identifier).to eq("10123")
    end
    
  end
  
  context "callbacks" do
    
    it "enqueues exports on save" do
      expect(ExportToGraphJob).to receive(:perform_async)
      expect(KeywordExtractorJob).to receive(:perform_async)
      SurveyResponse.create(response_id: "123456")
    end
    
    it "sanitizes array values on save" do
      survey_response = SurveyResponse.create(response_id: "123456", age_exp_codes: ["foo", "bar"])
      expect(survey_response.age_exp_codes).to eq(["foo", "bar"])
    end
    
  end
  
end
