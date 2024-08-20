# This background job hydrates the graph from a SurveyResponse.
class SentimentAnalysisJob

  include Sidekiq::Job

  queue_as :default

  def perform(id)
    return unless record = SurveyResponse.find(id)
    Rails.logger.info("SentimentAnalysisJob running with survey response ID #{id}")
    record.classify_sentiment
  end

end
