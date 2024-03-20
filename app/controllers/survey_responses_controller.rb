class SurveyResponsesController < ApplicationController
	
	USERS = { ENV['GENERAL_ADMISSION_USERNAME'] => ENV['GENERAL_ADMISSION_PASSWORD'] }
	
	before_action :authenticate
	
	def authenticate
		authenticate_or_request_with_http_digest("Application") do |name|
			USERS[name]
		end
	end

	def index
		@responses = SurveyResponse.all.order(:created_at)
	end
	
	def show
		@response = SurveyResponse.find(params[:id])
	end
	
	def new
	end
	
	def create
		permitted = params.permit(:csv)
		SurveyResponse.refresh_from_upload(permitted[:csv])
		redirect_to survey_responses_path
	end
	
	def question
		@question_label = params.permit(:q)[:q]
		@question_readable = SurveyResponse::QUESTION_MAPPING[params.permit(:q)[:q].to_sym]
		@responses = SurveyResponse.all.order(:created_at)
	end
	
end
