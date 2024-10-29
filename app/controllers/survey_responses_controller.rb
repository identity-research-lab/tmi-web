class SurveyResponsesController < ApplicationController

  def index
    @survey_responses = SurveyResponse.all.order(:created_at)
  end

  def show
    @survey_response = SurveyResponse.find(params[:id])
    @enqueued_at = params[:enqueued_at]

    @previous_response = SurveyResponse.where("created_at < ?", @survey_response.created_at).order("created_at DESC").limit(1).first
    @next_response = SurveyResponse.where("created_at > ?", @survey_response.created_at).order("created_at ASC").limit(1).first

    persona = Persona.find_or_initialize_by(survey_response_id: @survey_response.id)
    @categories = persona.categories.sort{ |a,b| "#{a.context}.#{a.name}" <=> "#{b.context}.#{b.name}" }
    @keywords = persona.keywords.order_by(:name)
    @annotation = @survey_response.annotation || Annotation.new(survey_response_id: @survey_response.id)
    @responses = @survey_response.responses.order(:created_at)
  end

  def new
  end

  def create
    Services::ImportFromCsv.perform(params.permit(:csv)[:csv])
    redirect_to survey_responses_path
  end

  def enqueue_keywords
    KeywordExtractorJob.perform_async(params[:survey_response_id])
    redirect_to( action: :show, id: params[:survey_response_id], params: {enqueued_at: Time.now.strftime("%I:%M:%S %P (%Z)")} )
  end

end
