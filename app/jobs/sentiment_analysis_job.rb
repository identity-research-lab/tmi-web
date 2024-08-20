# This background job triggers sentiment analysis on the identified SurveyResponse.
class SentimentAnalysisJob

  include Sidekiq::Job

  queue_as :default

  def perform(id)
    return unless record = SurveyResponse.find(id)
    Rails.logger.info("SentimentAnalysisJob running with survey response ID #{id}")
    record.classify_sentiment
  end

end
