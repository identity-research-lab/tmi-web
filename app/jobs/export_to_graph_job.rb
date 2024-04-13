class ExportToGraphJob < ApplicationJob
  queue_as :default

  attr_accessor :survey_response
  
  def perform(record)
    return unless record

    # TODO this is a hack until sidekiq is set up
    sleep(rand(0.2..2.0))
    
    record.to_graph
  end

end
