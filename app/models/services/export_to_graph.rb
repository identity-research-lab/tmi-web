module Services

	# Translates data from a Case into nodes in the graph database.
	class ExportToGraph

		attr_accessor :response, :question, :context, :kase

		def self.perform(response_id)
			new(response_id).perform
		end

		def initialize(response_id)
			@response = Response.find(response_id)
			@kase = @response.case
			@question = @response.question
			@context = @question.context.name
		end

		def perform
			return false unless response
			if question.is_identity?
				populate_identities
			else
				populate_codes
			end
			return true
		end

		private

		# Hydrates a new Persona with data from the Case.
		def persona
			@persona ||= Persona.find_or_create_by(
				name: "Persona #{kase.identifier}",
				case_id: kase.id,
				permalink: kase.permalink
			)
		end

		# Creates Code nodes and connects them to the associated Persona.
		def populate_codes

			# Break association with previous codes in this context
			persona.codes = persona.codes.reject{ |c| c.context == context }

			# Clean up any Codes that are no longer associated with a Persona.
			Code.reap_orphans

			response.raw_codes.compact.uniq.each do |name|
				if code = Code.find_or_create_by(name: name, context: context)
					next unless code.valid?
					Experiences.create(from_node: persona, to_node: code)
				end
			end

		end

		# Creates Identity nodes and connects them to the associated Persona.
		def populate_identities

			persona.identities = persona.identities.reject{ |i| i.context == context }

			# Clean up any Identities that are no longer associated with a Persona.
			Identity.reap_orphans

			response.raw_codes.compact.uniq.each do |name|
				if identity = Identity.find_or_create_by(name: name.strip, context: context)
					next unless identity.valid?
					IdentifiesWith.create(from_node: persona, to_node: identity)
				end
			end

		end

	end
end
