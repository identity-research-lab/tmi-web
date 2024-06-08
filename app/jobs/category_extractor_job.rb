class CategoryExtractorJob
    
  include Sidekiq::Job
  
  queue_as :default
  
  def perform(context)
    Category.from_context(context)
  end
  
end
