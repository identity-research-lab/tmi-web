# This background job performs the Category derivation process.
class CategorySuggestionsJob

  include Sidekiq::Job

  queue_as :default

  def perform(context_id)
    Rails.logger.info("CategorySuggestionsJob running with context id #{context_id}")
    Context.suggest_categories
  end

end
