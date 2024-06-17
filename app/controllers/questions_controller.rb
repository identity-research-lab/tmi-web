class QuestionsController < ApplicationController
  
  USERS = { ENV['GENERAL_ADMISSION_USERNAME'] => ENV['GENERAL_ADMISSION_PASSWORD'] }
  
  before_action :authenticate
  
  def authenticate
    authenticate_or_request_with_http_digest("Application") do |name|
      USERS[name]
    end
  end

  def show
    @question = Question.from(params[:id])
    @responses = SurveyResponse.all.order(:created_at).reject{|sr| sr.read_attribute(@question.key).nil? }
  end
      
end
