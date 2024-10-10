module Services

	class GenerateWordCloud

		attr_accessor :text

		# This is the prompt passed to the LLM agent to serve as instructions for word cloud generation.
		WORD_CLOUD_PROMPT = %{
			You are going to help me create a word cloud. Generate a word frequency histogram from this corpus. Clean the text first by removing common words (stopwords), punctuation, and other unnecessary elements to focus on the most relevant words. Return the results as JSON, using this format:

      {
        "words" :
			  [
          {
            "word": "term1", "frequency": 11
          },
          {
            "word": "term2", "frequency": 9
          }
        ]
      }

			The text to analyze is as follows:
		}

		def self.perform(text)
			new(text).perform
		end

		def initialize(text)
			@text = text
		end

		# Uses the OpenAI client to pass the prompt and valid text through the API for word cloud generation.
		def perform
			return false unless text.present?
			response = Clients::OpenAi.request("#{WORD_CLOUD_PROMPT} #{self.text}")
			return false unless response['words'].present?
			return response['words']
 		end

	end
end
