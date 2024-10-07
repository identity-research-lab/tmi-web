class AnnotationsController < ApplicationController

  def create
    @response = SurveyResponse.find(sanitized_params[:survey_response_id])
    @annotation = Annotation.new(survey_response_id: @response.id, text: sanitized_params[:text])
    success = @annotation.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("annotation", partial: "/annotations/form", locals: { response: @response, annotation: @annotation, success: success  })
      end
    end
  end

  def update
    @response = SurveyResponse.find(sanitized_params[:survey_response_id])
    @annotation = Annotation.find_or_initialize_by(survey_response_id: @response.id)
    success = @annotation.update(text: sanitized_params[:text])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("annotation", partial: "/annotations/form", locals: { response: @response, annotation: @annotation, success: success  })
      end
    end
  end

  private

    def sanitized_params
      params.require(:annotation).permit(:survey_response_id, :text)
    end

end
