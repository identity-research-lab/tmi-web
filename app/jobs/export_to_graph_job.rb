# This background job performs the graph export process.
class ExportToGraphJob

	include Sidekiq::Job

	queue_as :default

	def perform(id)
		Rails.logger.info("ExportToGraphJob running with response #{id}")
		Services::ExportToGraph.perform(id)
	end

end
