class AnnotationsController < ApplicationController

  def create
    @survey_response = SurveyResponse.find(sanitized_params[:survey_response_id])
    @annotation = Annotation.new(survey_response_id: @survey_response.id, text: sanitized_params[:text])
    success = @annotation.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("annotation", partial: "/annotations/form", locals: { response: @survey_response, annotation: @annotation, success: success  })
      end
    end
  end

  def update
    @survey_response = SurveyResponse.find(sanitized_params[:survey_response_id])
    @annotation = Annotation.find_or_initialize_by(survey_response_id: @survey_response.id)
    @annotation.text = sanitized_params[:text]
    if sanitized_params[:text].empty?
      success = @annotation.destroy
    else
      success = @annotation.save
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("annotation", partial: "/annotations/form", locals: { response: @survey_response, annotation: @annotation, success: success  })
      end
    end
  end

  private

    def sanitized_params
      params.require(:annotation).permit(:survey_response_id, :text)
    end

end
