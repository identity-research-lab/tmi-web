class KeywordExtractorJob
    
  include Sidekiq::Job
  
  queue_as :default
  
  def perform(context)
    Keyword.from(context)
  end
  
end
