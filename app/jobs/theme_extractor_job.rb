class ThemeExtractorJob

  include Sidekiq::Job

  queue_as :default

  def perform(id)
    return unless survey_response = SurveyResponse.find(id)
    survey_response.set_themes
  end

end
