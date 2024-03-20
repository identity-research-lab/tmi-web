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
		@question_readable = SurveyResponse::QUESTION_MAPPING[params.permit(:q)[:q].to_sym] || @question_label.to_sym
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
			params.require(:survey_response).permit(tags: [], age_coping_tags: [], klass_coping_tags: [], race_coping_tags: [], religion_coping_tags: [], disability_coping_tags: [], neurodiversity_coping_tags: [], gender_coping_tags: [], lgbtq_coping_tags: [])
		end

end
