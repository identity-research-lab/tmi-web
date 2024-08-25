# This background job performs the graph export process.
class ExportToGraphJob
		
	include Sidekiq::Job
	
	queue_as :default
	
	def perform(id)
		Rails.logger.info("ExportToGraphJob running with survey response #{id}")
		ExportToGraph.perform(id)
	end
	
end
