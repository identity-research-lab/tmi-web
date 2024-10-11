require 'rails_helper'

RSpec.describe Services::ImportFromCsv do

	before do
		allow_any_instance_of(SurveyResponse).to receive(:enqueue_export_to_graph)
		allow_any_instance_of(SurveyResponse).to receive(:enqueue_keyword_extraction)
		allow_any_instance_of(SurveyResponse).to receive(:enqueue_sentiment_analysis)
    allow_any_instance_of(SurveyResponse).to receive(:enqueue_wordcloud_generation)
	end

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
		Services::ImportFromCsv.new(complete_record).perform
		Services::ImportFromCsv.new(incomplete_record).perform
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
