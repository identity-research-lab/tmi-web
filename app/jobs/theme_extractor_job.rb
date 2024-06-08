class ThemeExtractorJob < ApplicationJob
  queue_as :default

  attr_accessor :survey_response
  
  def perform(record)
    return unless record
    self.survey_response = record
    set_themes
  end

  def set_themes
    txt = survey_response.corpus

    # TODO this is a hack until sidekiq is set up
    sleep(rand(0.2..2.0))

    client = OpenAI::Client.new
    if response = client.chat( parameters: { model: "gpt-3.5-turbo", 
      messages: [{ 
        role: "user", 
        content: "#{SurveyResponse::THEME_PROMPT} #{txt}"
      }], temperature: 0.7 } )	
      survey_response.update_attribute( :themes, response.dig("choices", 0, "message", "content").downcase.split(/[\,\.][\s]*/))
    end	
  end
end
