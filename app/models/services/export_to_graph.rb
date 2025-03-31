module Services

	# Updates associated codes and identities from a Response in the graph database.
	class ExportToGraph

		attr_accessor :response

		def self.perform(response_id)
			new(response_id).perform
		end

		def initialize(response_id)
			@response = Response.find(response_id)
		end

		def perform
			return false unless response
			response.sync_to_graph
			return true
		end

	end
end
