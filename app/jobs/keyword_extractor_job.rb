# This background job performs the Keyword extraction process.
class KeywordExtractorJob

  include Sidekiq::Job

  queue_as :default

  def perform(dimension)
    Rails.logger.info("KeywordExtractorJob running with dimension #{dimension}")
    Keyword.from(dimension)
  end

end
