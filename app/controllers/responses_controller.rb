class ResponsesController < ApplicationController

  def update
    @response = Response.find(params[:id])
    success = @response.update(raw_codes: response_params[:raw_codes].join(",").split(",").reject(&:empty?).compact.map(&:strip).map(&:downcase))

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("frame-response-#{@response.id}", partial: "/responses/form", locals: { response: @response, success: success, filters: false  })
      end
    end
  end

  private

  def response_params
    params.require(:response).permit(raw_codes: [])
  end

end
