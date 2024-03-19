class SurveyResponsesController < ApplicationController
	
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
	
end
