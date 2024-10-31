# This background job performs the Keyword extraction process.
class PopulateCodeJob

  include Sidekiq::Job

  queue_as :default

  def perform(context, record)
    Rails.logger.info("PopulateCodeJob running with context #{context}")
    kase = Case.from(context, record)
    kase.generate_wordcloud
    kase.classify_sentiment
    Keyword.from(self.id)
  end

end

