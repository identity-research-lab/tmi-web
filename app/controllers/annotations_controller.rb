class AnnotationsController < ApplicationController

  def create
    @kase = Case.find(sanitized_params[:case_id])
    @annotation = Annotation.new(case_id: @kase.id, text: sanitized_params[:text])
    success = @annotation.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("annotation", partial: "/annotations/form", locals: { case: @kase, annotation: @annotation, success: success  })
      end
    end
  end

  def update
    @kase = Case.find(sanitized_params[:case_id])
    @annotation = Annotation.find_or_initialize_by(case_id: @kase.id)
    @annotation.text = sanitized_params[:text]
    if sanitized_params[:text].empty?
      success = @annotation.destroy
    else
      success = @annotation.save
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("annotation", partial: "/annotations/form", locals: { case: @kase, annotation: @annotation, success: success  })
      end
    end
  end

  private

    def sanitized_params
      params.require(:annotation).permit(:case_id, :text)
    end

end
