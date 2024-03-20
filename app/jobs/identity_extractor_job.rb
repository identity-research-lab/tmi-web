class IdentityExtractorJob < ApplicationJob
  queue_as :default

  attr_accessor :survey_response, :attribute
  
  def perform(record, attr)
    self.survey_response = record
    self.attribute = attr
    set_identities
  end

  def set_identities

    return unless txt = self.survey_response.read_attribute(self.attribute)
    return if txt.empty?
    
    identity_attr = self.attribute.to_s.gsub("_given","_identities").to_sym
    
    client = OpenAI::Client.new
    if response = client.chat( parameters: { model: "gpt-3.5-turbo", 
      messages: [{ 
        role: "user", 
        content: "#{SurveyResponse::IDENTITY_PROMPT} \"#{txt}\""
      }], temperature: 0.7 } )	
      survey_response.update_attribute( identity_attr, response.dig("choices", 0, "message", "content").downcase.split(/[\,\.][\s]*/))
      end	
  end
end
