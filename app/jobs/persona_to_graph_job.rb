class PersonaToGraphJob < ApplicationJob
  queue_as :default

  attr_accessor :survey_response
  
  def perform(record)
    return unless record
    record.to_graph
  end

end
