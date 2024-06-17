class KeywordExtractorJob
    
  include Sidekiq::Job
  
  queue_as :default
  
  def perform(context)
    Rails.logger.info("KeywordExtractorJob running with context #{context}")
    Keyword.from(context)
  end
  
end
