class CodebooksController < ApplicationController
	
	USERS = { ENV['GENERAL_ADMISSION_USERNAME'] => ENV['GENERAL_ADMISSION_PASSWORD'] }
	
	before_action :authenticate
	
	def authenticate
		authenticate_or_request_with_http_digest("Application") do |name|
			USERS[name]
		end
	end

	def index
		@contexts = Tag.all.pluck(:context).uniq.sort
	end
	
	def show
		@context = params[:id]
		@frequencies = Tag.histogram(@context)
		@section_name = SurveyResponse::QUESTION_MAPPING[@context.to_sym]
	end
	
end
