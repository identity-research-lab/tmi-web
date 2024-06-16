class Keyword

	# Keywords are the nouns extracted from a 'corpus' consisting of the exact text of
	# certain freeform response fields. The extraction is performed using AI assistance.

	include ActiveGraph::Node
	
	property :name
	
	validates :name, presence: true

	has_many :in, :personas, rel_class: :ReflectsOn, dependent: :delete_orphans

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
		corpus = survey_response.notes

		response = Clients::OpenAi.request("#{PROMPT} #{corpus}")
		response['words'].compact.uniq.each do |word|
			if keyword = Keyword.find_or_create_by(name: word.downcase)
				ReflectsOn.create(from_node: persona, to_node: keyword )
			end
		end

	end

end 
