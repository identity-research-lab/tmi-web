require 'rails_helper'

RSpec.describe SurveyResponse do

  before do
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

end
