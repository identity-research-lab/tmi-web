class Keyword

	# Keywords are the nouns that are present in the "reflective" or freeform responses. 
	# They are extracted from a 'corpus' consisting of the exact text of these responses.
	# The extraction is performed using AI assistance.

	include ActiveGraph::Node
	
	property :name
	
	validates :name, presence: true

	has_many :in, :personas, rel_class: :DescribesWith, dependent: :delete_orphans

	PROMPT = %{
		Given a text, extract just the nouns and return them using this JSON example as the format:
		
		{ 
			"words" : ["foo", "bar", "baz", "bat]
		}
		
		The text is as follows: 
	}

	def self.from(survey_response_id)
		survey_response = SurveyResponse.find(survey_response_id)
		persona = Persona.find_by(survey_response_id: survey_response_id)
		corpus = Question.freeform_questions.map{ |q| survey_response.send(q) }.compact.join(" .")
		client = OpenAI::Client.new

		response = client.chat(
			parameters: {
				model: "gpt-4o",
				response_format: { type: "json_object" },
				messages: [{ role: "user", content: "#{PROMPT} #{corpus}" }],
				temperature: 0.7,
			}
		)	
	
		data = JSON.parse(response.dig("choices", 0, "message", "content"))
		data['words'].compact.uniq.each do |word|
			if keyword = Keyword.find_or_create_by(name: word.downcase)
				DescribesWith.create(from_node: persona, to_node: keyword )
			end
		end

	end

end 
