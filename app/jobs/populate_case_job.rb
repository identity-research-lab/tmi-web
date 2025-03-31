# This background job performs the Keyword extraction process.
class PopulateCaseJob

  include Sidekiq::Job

  queue_as :default

  def perform(dimension, record)
    Rails.logger.info("PopulateCodeJob running with dimension #{dimension}")
    kase = Case.from(dimension, record)
    kase.generate_wordcloud
    kase.classify_sentiment
    Keyword.from(self.id)
  end

end

