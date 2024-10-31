module Services
	class SuggestCategories

		attr_accessor :context

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

			The array of codes is:
		}

		def self.perform(context_id)
			new(context_id).perform
		end

		def initialize(context_id)
			@context = Context.find(context_id)
		end

		# Uses the OpenAI client to pass the prompt and text through the API for sentiment analysis.
		def perform
			return false unless context.present?
			codes = Code.where(context: context.name).map(&:name)

			response = Clients::OpenAi.request("#{PROMPT} #{codes}")
			# response = { "categories" => [ { "category" => "divisions" }, { "category" => "third space" }, { "category" => "intergenerational" } ] }

			return false unless response['categories'].present?
			return response['categories']
 		end

	end
end
