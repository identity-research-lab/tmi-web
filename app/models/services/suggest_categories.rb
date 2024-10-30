module Services
	class SuggestCategories

		attr_accessor :text

		# This is the prompt sent to the selected AI agent to provide instructions on category derivision.
		PROMPT = %{
			You are a social researcher doing data analysis. Please generate a list of the most relevant categories from the following list of codes. The categories should be all lowercase and contain no punctuation. Return each category with an array of its applicable codes in JSON format.Do not remove any punctuation from the codes that are returned. Use this JSON as the output format:

			{
				"categories" : [
					{
						"category": "foo",
						"codes": [ "bar", "bat", "baz"]
					}
				]
			}

			The codes are provided in the following list:
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
