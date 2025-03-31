module Services
	class SuggestCategories

		attr_accessor :dimension

		# This is the prompt sent to the selected AI agent to provide instructions on category derivision.
		PROMPT = %{
			You are a social researcher doing qualitative analysis on identity-related survey data. Please generate a list of no more than 7 suggested categories from a list of codes. The categories should be all lowercase and contain no punctuation. Use this JSON as the output format:

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

			The array of codes is:
		}

		def self.perform(dimension_id)
			new(dimension_id).perform
		end

		def initialize(dimension_id)
			@dimension = Dimension.find(dimension_id)
		end

		# Uses the OpenAI client to pass the prompt and text through the API for sentiment analysis.
		def perform
			return false unless dimension.present?
			codes = Code.where(dimension: dimension.name).map(&:name)
			response = Clients::OpenAi.request("#{PROMPT} #{codes}")
			return false unless response['categories'].present?
			return response['categories']
 		end

	end
end
