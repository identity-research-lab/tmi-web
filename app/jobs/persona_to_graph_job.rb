class PersonaToGraphJob

  include Sidekiq::Job

  queue_as :default

  def perform(record)
    return unless record
    record.to_graph
  end

end
