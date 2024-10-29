# This background job performs the Keyword extraction process.
class PopulateSurveyResponseJob

  include Sidekiq::Job

  queue_as :default

  def perform(context, record)
    Rails.logger.info("PopulateSurveyResponseJob running with context #{context}")
    survey_response = SurveyResponse.from(context, record)
    survey_response.generate_wordcloud
    survey_response.classify_sentiment
    Keyword.from(self.id)
  end

end

