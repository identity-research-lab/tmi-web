class QuestionsController < ApplicationController
  
  USERS = { ENV['GENERAL_ADMISSION_USERNAME'] => ENV['GENERAL_ADMISSION_PASSWORD'] }
  
  def show
    @question = Question.from(params[:id])
    @responses = SurveyResponse.all.order(:created_at).reject{|sr| sr.read_attribute(@question.key).nil? }
  end
      
end
