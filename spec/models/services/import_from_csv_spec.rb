require 'rails_helper'

RSpec.describe Services::ImportFromCsv do

	before do
		allow_any_instance_of(Case).to receive(:enqueue_keyword_extraction)
		allow_any_instance_of(Case).to receive(:enqueue_sentiment_analysis)
  	allow_any_instance_of(Case).to receive(:enqueue_wordcloud_generation)
    allow(Question).to receive(:identity_questions).and_return([question])
	end

  let(:question) {
    Question.new(key: "age_given")
  }

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

  let(:kase) {
    Case.new(id: 1)
  }

	it 'creates from a valid record' do
		expect(Case).to receive(:find_or_create_by).with(response_id: "123456").and_return(kase)
    expect(PopulateCaseJob).to receive(:perform_async)
		Services::ImportFromCsv.new(complete_record).perform
	end

	it 'does not create from an incomplete record' do
		expect(Case).to_not receive(:find_or_create_by).with(response_id: "123456")
    expect(PopulateCaseJob).to_not receive(:perform_async)
		Services::ImportFromCsv.new(incomplete_record).perform
	end

end
