class CodebooksController < ApplicationController
	
	USERS = { ENV['GENERAL_ADMISSION_USERNAME'] => ENV['GENERAL_ADMISSION_PASSWORD'] }
	
	before_action :authenticate
	
	def authenticate
		authenticate_or_request_with_http_digest("Application") do |name|
			USERS[name]
		end
	end

	def index
		@contexts = SurveyResponse::QUESTION_MAPPING
	end
	
	def show
		@context = params[:id]
		if params[:id].split('_').last == "given"
			@frequencies = Identity.histogram(@context.gsub("_given","").gsub("klass","class").to_sym)
		else
			@frequencies = Tag.histogram(@context.gsub("_exp","").gsub("klass","class").to_sym)
		end
		@section_name = SurveyResponse::QUESTION_MAPPING[@context.to_sym]
		sections = SurveyResponse::QUESTION_MAPPING.keys
		@previous_section = sections[sections.index(@context.to_sym) - 1]
		@next_section = sections[sections.index(@context.to_sym) + 1]
	end
	
end
