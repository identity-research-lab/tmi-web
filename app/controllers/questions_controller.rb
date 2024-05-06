class QuestionsController < ApplicationController
	
	USERS = { ENV['GENERAL_ADMISSION_USERNAME'] => ENV['GENERAL_ADMISSION_PASSWORD'] }
	
	before_action :authenticate
	
	def authenticate
		authenticate_or_request_with_http_digest("Application") do |name|
			USERS[name]
		end
	end

	def show
		@question_label = params[:id]
		@question_readable = SurveyResponse::QUESTION_MAPPING[params[:id].to_sym] || @question_label.to_sym
		@question_field = "#{@question_label.gsub(/given/, 'id')}_tags".to_sym
		@responses = SurveyResponse.all.order(:created_at).reject{|sr| sr.read_attribute(@question_label.to_sym).nil? }
	end
			
end
