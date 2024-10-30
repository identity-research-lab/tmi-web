# This background job performs the Keyword extraction process.
class PopulateSurveyResponseJob

  include Sidekiq::Job

  queue_as :default

  def perform(survey_response_id, record)
    Rails.logger.info("PopulateSurveyResponseJob running with record id #{survey_response_id}")

    survey_response = SurveyResponse.find(survey_response_id)

    Question.all.each do |question|
      Response.find_or_create_by!(question_id: question.id, survey_response_id: survey_response.id, value: record[question.key])
    end

    Services::ExportToGraph.perform(survey_response.id)
    survey_response.generate_wordcloud
    survey_response.classify_sentiment
    Keyword.from(self.id)
  end

end

