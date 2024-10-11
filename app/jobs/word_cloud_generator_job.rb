# This background job triggers histogram generation on the identified SurveyResponse.
class WordCloudGeneratorJob

  include Sidekiq::Job

  queue_as :default

  def perform(id)
    return unless record = SurveyResponse.find(id)
    Rails.logger.info("WordCloudGeneratorJob running with survey response ID #{id}")
    record.generate_wordcloud
  end

end
