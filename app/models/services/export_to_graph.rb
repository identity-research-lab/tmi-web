module Services

	# Translates data from a SurveyResponse into nodes in the graph database.
	class ExportToGraph

		attr_accessor :survey_response

		def self.perform(survey_response_id)
			new(survey_response_id).perform
		end

		def initialize(survey_response_id)
			@survey_response = SurveyResponse.find(survey_response_id)
		end

		def perform
			return false unless survey_response

			# Destroy the existing persona so that neo4j will reap orphaned nodes like Codes and Identities.
			Persona.find_or_initialize_by(survey_response_id: survey_response.id).destroy
			populate_codes
			return true
		end

		private

		# Hydrates a new Persona with data from the SurveyResponse.
		def persona
			@persona ||= Persona.find_or_create_by(
				name: "Persona #{survey_response.identifier}",
				survey_response_id: survey_response.id,
				permalink: survey_response.permalink
			)
		end

		# Creates Code nodes and connects them to the associated Persona.
		def populate_codes
			survey_response.responses.each do |response|
				question = response.question
				context = question.context.name
				response.raw_codes.compact.uniq.each do |name|
					if question.is_identity?
						if identity = Identity.find_or_create_by(name: name.strip, context: context)
						next unless identity.valid?
						IdentifiesWith.create(from_node: persona, to_node: identity)
					else
						if code = Code.find_or_create_by(name: name, context: context)
							next unless code.valid?
							Experiences.create(from_node: persona, to_node: code)
						end
					end
				end
			end
		end

	end
end
