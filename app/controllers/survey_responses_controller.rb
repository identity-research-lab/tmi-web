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
		@responses = SurveyResponse.all.order(:created_at).reject{|sr| sr.read_attribute(@question_label).nil? }
	end
	
	def update
		@response = SurveyResponse.find(params[:id])
	
		if @response.update(response_params)
#			redirect_to @response
		else
			render :edit, status: :unprocessable_entity
		end
	end
	
	private

		def response_params
			params.require(:survey_response).permit(age_coping_themes: [], klass_coping_themes: [], race_coping_themes: [], religion_coping_themes: [], disability_coping_themes: [], neurodiversity_coping_themes: [], gender_coping_themes: [], lgbtq_coping_themes: [])
		end

end
