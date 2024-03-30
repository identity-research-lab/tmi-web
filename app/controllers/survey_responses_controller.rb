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
		SurveyResponse.refresh_from_upload(params.permit(:csv)[:csv])
		redirect_to survey_responses_path
	end
	
	def update
		@response = SurveyResponse.find(params[:id])
	
		unless @response.update(response_params)
			render :edit, status: :unprocessable_entity
		end
	end

	def question
		@question_label = params.permit(:q)[:q]
		@question_readable = SurveyResponse::QUESTION_MAPPING[params.permit(:q)[:q].to_sym] || @question_label.to_sym
		@responses = SurveyResponse.all.order(:created_at).reject{|sr| sr.read_attribute(@question_label).nil? }
	end
		
	private

		def response_params
			params.require(:survey_response).permit(themes: [], age_exp_tags: [], klass_exp_tags: [], race_ethnicity_exp_tags: [], religion_exp_tags: [], disability_exp_tags: [], neurodiversity_exp_tags: [], gender_exp_tags: [], lgbtqia_exp_tags: [], age_id_tags: [], klass_id_tags: [], race_ethnicity_id_tags: [], religion_id_tags: [], disability_id_tags: [], neurodiversity_id_tags: [], gender_id_tags: [], lgbtqia_id_tags: [])
		end

end
