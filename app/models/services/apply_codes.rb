module Services
	class ApplyCodes

		attr_accessor :text, :context

		# This is the prompt sent to the selected AI agent to provide instructions on category derivision.
		PROMPT = %{
			You are a social scientist studying survey data. I want you to select codes from the provided list that most closely describe the provided survey answer. Return the list of codes and a confidence score percentage using this JSON format:

			{
				"tags": [
					{ foo: "bar", confidence: 92 },
					{ tag: "bar", confidence: 80 },
			}

			The list of tags is as follows: [ LIST_OF_TAGS ]

			The text to classify is as follows: "
		}

		CONFIDENCE_THRESHOLD = 80

		def self.perform(text, context)
			new(text, context).perform
		end

		def initialize(text, context)
			@text = text
			@context = context
		end

		# Uses the OpenAI client to pass the prompt and text through the API for sentiment analysis.
		def perform
			return false unless text.present?
			return false unless context.present?
			codes = Code.where(context: context).map(&:name).join(", ")
			response = Clients::OpenAi.request("#{ PROMPT.gsub("LIST_OF_TAGS", codes) } #{self.text}")
			return false unless response['tags'].present?
			codes_to_apply = response['tags'].select {|r| r['confidence'] > CONFIDENCE_THRESHOLD }.map{ |r| r['tag'] }
			return codes_to_apply
 		end

	end
end
