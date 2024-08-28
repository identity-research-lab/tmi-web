require 'rails_helper'

RSpec.describe Services::SentimentAnalysis do

	before do
		allow(Clients::OpenAi).to receive(:request).and_return(response)
	end

	let(:response) { { "sentiment" => "positive" } }

	context "invalid text" do

		let(:text) { nil }
		let(:service) { Services::SentimentAnalysis.new(text) }

		it "returns false" do
			expect(service.perform).to eq(false)
		end

	end

	context "valid text" do

		let(:text) { "It was a dark and stormy night." }
		let(:service) { Services::SentimentAnalysis.new(text) }

		it "returns the classification" do
			expect(service.perform).to eq("positive")
		end

	end

end
