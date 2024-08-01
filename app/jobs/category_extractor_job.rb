# This background job performs the Category derivation process.
class CategoryExtractorJob
    
  include Sidekiq::Job
  
  queue_as :default
  
  def perform(context)
    Rails.logger.info("CategoryExtractorJob running with context #{context}")
    Category.from(context)
  end
  
end
