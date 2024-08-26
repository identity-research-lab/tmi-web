class SentimentAnalysis

	attr_accessor :text

	# This is the prompt passed to the LLM agent to serve as instructions for sentiment analysis.
	SENTIMENT_PROMPT = %{
		You are a social science researcher doing textual analysis on survey data. Perform sentiment analysis against the provided text, classifying it as "positive", "negative", or "neutral". Return the classification encoded as JSON in the following format:

		{
			"sentiment" : "positive"
		}

		The text to perform sentiment analysis on is as follows:
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

		response = Clients::OpenAi.request("#{SENTIMENT_PROMPT} #{self.text}")
		return false unless response['sentiment'].present?

		classification = response['sentiment'].strip.downcase
		return classification
 	end


end
