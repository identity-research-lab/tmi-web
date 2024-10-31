# This background job performs the Category derivation process.
class CategorySuggestionsJob

  include Sidekiq::Job

  queue_as :default

  def perform(context_id)
    Rails.logger.info("CategorySuggestionsJob running with context id #{context_id}")
    return unless context = Context.find(context_id)
    sleep(2)
    context.suggest_categories
    context.update_attribute(:suggestions_updated_at, DateTime.now)
  end

end
