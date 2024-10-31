# This background job triggers histogram generation on the identified Case.
class WordCloudGeneratorJob

  include Sidekiq::Job

  queue_as :default

  def perform(id)
    return unless record = Case.find(id)
    Rails.logger.info("WordCloudGeneratorJob running with case #{id}")
    record.generate_wordcloud
  end

end
