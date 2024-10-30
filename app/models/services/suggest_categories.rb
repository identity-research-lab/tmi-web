module Services
	class SuggestCategories

		attr_accessor :text

		# This is the prompt sent to the selected AI agent to provide instructions on category derivision.
		PROMPT = %{
			You are a social researcher doing qualitative analysis on survey data. Please generate a list of suggested categories from a list of codes. The categories should be all lowercase and contain no punctuation. Use this JSON as the output format:

			{
				"categories" : [
					{
						"category": "foo"
					},
					{
						"category": "bar"
					},

				]
			}

			The list of codes is:
		}

		def self.perform(text)
			new(text).perform
		end

		def initialize(text)
			@text = text
		end

		# Uses the OpenAI client to pass the prompt and text through the API for sentiment analysis.
		def perform
			return false unless text.present?
			response = Clients::OpenAi.request("#{PROMPT} #{text}")
			return false unless response['categories'].present?
			return response['categories']
 		end

	end
end
