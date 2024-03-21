class ThemeExtractorJob < ApplicationJob
  queue_as :default

  attr_accessor :survey_response
  
  def perform(record)
    return unless record
    self.survey_response = record
    set_themes
  end

  def set_themes
    txt = "#{self.survey_response.age_exp} #{self.survey_response.klass_exp} #{self.survey_response.race_ethnicity_exp} #{self.survey_response.religion_exp} #{self.survey_response.disability_exp} #{self.survey_response.neurodiversity_exp} #{self.survey_response.gender_exp} #{self.survey_response.lgbtqia_exp}"

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
