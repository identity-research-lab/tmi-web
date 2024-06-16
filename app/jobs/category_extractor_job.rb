class CategoryExtractorJob
    
  include Sidekiq::Job
  
  queue_as :default
  
  def perform(context)
    Category.from(context)
  end
  
end
