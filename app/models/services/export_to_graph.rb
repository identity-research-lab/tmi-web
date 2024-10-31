module Services

	# Translates data from a SurveyResponse into nodes in the graph database.
	class ExportToGraph

		attr_accessor :kase

		def self.perform(case_id)
			new(case_id).perform
		end

		def initialize(case_id)
			@kase = Case.find(case_id)
		end

		def perform
			return false unless kase

			# Destroy the existing persona so that neo4j will reap orphaned nodes like Codes and Identities.
			Persona.find_or_initialize_by(case_id: kase.id).destroy
			populate_codes
			populate_identities
			return true
		end

		private

		# Hydrates a new Persona with data from the SurveyResponse.
		def persona
			@persona ||= Persona.find_or_create_by(
				name: "Persona #{kase.identifier}",
				case_id: kase.id,
				permalink: kase.permalink
			)
		end

		# Creates Code nodes and connects them to the associated Persona.
		def populate_codes
			kase.responses.each do |response|
				question = response.question
				next if question.is_identity?

				context = question.context.name

				response.raw_codes.compact.uniq.each do |name|
					if code = Code.find_or_create_by(name: name, context: context)
						next unless code.valid?
						Experiences.create(from_node: persona, to_node: code)
					end
				end
			end
		end

		# Creates Identity nodes and connects them to the associated Persona.
		def populate_identities
			kase.responses.each do |response|
				question = response.question
				next unless question.is_identity?

				context = question.context.name

				response.raw_codes.compact.uniq.each do |name|
					if identity = Identity.find_or_create_by(name: name.strip, context: context)
						next unless identity.valid?
						IdentifiesWith.create(from_node: persona, to_node: identity)
					end
				end
			end
		end

	end
end
