require 'rails_helper'

RSpec.describe SurveyResponse do

  before do
    allow_any_instance_of(SurveyResponse).to receive(:enqueue_export_to_graph)
    allow_any_instance_of(SurveyResponse).to receive(:enqueue_keyword_extraction)
    allow_any_instance_of(SurveyResponse).to receive(:enqueue_sentiment_analysis)
    allow_any_instance_of(SurveyResponse).to receive(:enqueue_wordcloud_generation)
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

    it "sanitizes array values on save" do
      survey_response = SurveyResponse.create(response_id: "123456", age_exp_codes: ["foo", "bar"])
      expect(survey_response.age_exp_codes).to eq(["foo", "bar"])
    end

  end

end
