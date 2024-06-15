class Keyword

	# Keywords are the nouns that are present in an "experiences" response. 
	# They are extracted from a 'corpus' consisting of the exact text of the response
	# The extraction is performed using AI assistance.

	include ActiveGraph::Node
	
	property :name
	property :context
	
	validates :name, presence: true
	validates :context, presence: true

	has_many :in, :personas, rel_class: :DescribesWith, dependent: :delete_orphans

	PROMPT = %{
		Given a text, extract just the nouns and return them using this JSON example as the format:
		
		{ 
			"nouns" : ["foo", "bar", "baz", "bat]
		}
		
		The text is as follows: 
	}

	def self.enqueue_keyword_extractor_job(survey_response_id)
		KeywordExtractorJob.perform_async(survey_response_id)
	end

	def self.from(survey_response_id)
		survey_response = SurveyResponse.find(survey_response_id)
		persona = Persona.find_by(survey_response_id: survey_response_id)
		
		client = OpenAI::Client.new

		questions = Question.experience_questions + Question.freeform_questions
		
		questions.each do |question|
			
			next unless corpus = survey_response.send(question.to_sym)
										
			response = client.chat(
				parameters: {
					model: "gpt-4o",
					response_format: { type: "json_object" },
					messages: [{ role: "user", content: "#{PROMPT} #{corpus}" }],
					temperature: 0.7,
				}
			)	
	
			data = JSON.parse(response.dig("choices", 0, "message", "content"))['nouns']
	
			data.each do |noun|
				keyword = Keyword.find_or_create_by(name: noun, context: question)
				DescribesWith.create(from_node: persona, to_node: keyword )
			end

		end
	end

end 
