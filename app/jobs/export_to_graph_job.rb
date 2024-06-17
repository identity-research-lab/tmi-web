class ExportToGraphJob

  include Sidekiq::Job

  queue_as :default

  def perform(id)
    return unless record = SurveyResponse.find(id)
    Rails.logger.info("ExportToGraphJob running with survey response ID #{id}")
    record.to_graph
  end

end
