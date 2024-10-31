class ResponsesController < ApplicationController

  def update
    @kase = Response.find(params[:id])
    success = @kase.update(raw_codes: case_params[:raw_codes].join(",").split(",").reject(&:empty?).compact.map(&:strip).map(&:downcase))

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("frame-case-#{@kase.id}", partial: "/cases/form", locals: { case: @kase, success: success, filters: false  })
      end
    end
  end

  private

  def case_params
    params.require(:case).permit(raw_codes: [])
  end

end
