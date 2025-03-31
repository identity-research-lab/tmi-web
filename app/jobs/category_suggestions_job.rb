# This background job performs the Category derivation process.
class CategorySuggestionsJob

  include Sidekiq::Job

  queue_as :default

  def perform(dimension_id)
    Rails.logger.info("CategorySuggestionsJob running with dimension id #{dimension_id}")
    return unless dimension = Dimension.find(dimension_id)
    dimension.suggest_categories
    dimension.update_attribute(:suggestions_updated_at, DateTime.now)
  end

end
