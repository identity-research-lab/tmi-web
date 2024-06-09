class ExportToGraphJob

  include Sidekiq::Job

  queue_as :default

  def perform(id)
    return unless record = SurveyResponse.find(id)
    record.to_graph
  end

end
