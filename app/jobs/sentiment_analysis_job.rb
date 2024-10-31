# This background job triggers sentiment analysis on the identified Case.
class SentimentAnalysisJob

  include Sidekiq::Job

  queue_as :default

  def perform(id)
    return unless record = Case.find(id)
    Rails.logger.info("SentimentAnalysisJob running with case #{id}")
    record.classify_sentiment
  end

end
