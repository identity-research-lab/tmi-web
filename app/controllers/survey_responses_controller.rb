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
		SurveyResponse.refresh_from_upload(permitted[:csv])
		redirect_to survey_responses_path
	end
	
	def update
		@response = SurveyResponse.find(params[:id])
	
		if @response.update(response_params)
#			redirect_to @response
		else
			render :edit, status: :unprocessable_entity
		end
	end

	def question
		@question_label = params.permit(:q)[:q]
		@question_readable = SurveyResponse::QUESTION_MAPPING[params.permit(:q)[:q].to_sym] || @question_label.to_sym
		@responses = SurveyResponse.all.order(:created_at).reject{|sr| sr.read_attribute(@question_label).nil? }
	end
	
	def export
		if params[:destination] == "neo4j"
			SurveyResponse.queue_export_to_neo4j
			@exported = "neo4j"
			render :export
		end
	end
	
	
	private

		def response_params
			params.require(:survey_response).permit(tags: [], age_exp_tags: [], klass_exp_tags: [], race_ethnicity_exp_tags: [], religion_exp_tags: [], disability_exp_tags: [], neurodiversity_exp_tags: [], gender_exp_tags: [], lgbtqia_exp_tags: [])
		end

end
