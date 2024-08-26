class DeriveThemes

	attr_accessor :text

	# This is the prompt sent to the selected AI agent to provide instructions on category derivision.
	PROMPT = %{
		You are a social researcher doing data analysis. Please generate a list of the 20 most relevant themes from the following list of codes. The themes should be all lowercase and contain no punctuation. Codes should be stripped of quotation marks. Return each code with an array of its categories in JSON format. Use this JSON as the format:
	
		{
			"themes" : [
				{
					"theme": "foo",
					"codes": [ "bar", "bat", "baz"]
				}
			]
		}
	
		The codes are as follows:
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

		response = Clients::OpenAi.request("#{PROMPT} #{self.text}")
		return false unless response['sentiment'].present?

		classification = response['sentiment'].strip.downcase
		return classification
 	end


end
