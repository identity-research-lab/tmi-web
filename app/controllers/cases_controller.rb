class CasesController < ApplicationController

  def index
    @cases = Case.all.order(:created_at)
  end

  def show
    @kase = Case.find(params[:id])
    @previous_response = Case.where("created_at < ?", @kase.created_at).order("created_at DESC").limit(1).first
    @next_response = Case.where("created_at > ?", @kase.created_at).order("created_at ASC").limit(1).first

    persona = Persona.find_or_initialize_by(case_id: @kase.id)
    @categories = persona.categories.sort{ |a,b| "#{a.context}.#{a.name}" <=> "#{b.context}.#{b.name}" }
    @keywords = persona.keywords.order_by(:name)
    @annotation = @kase.annotation || Annotation.new(case_id: @kase.id)
    @responses = @kase.responses.order(:created_at)
  end

  def new
  end

  def create
    Services::ImportFromCsv.perform(params.permit(:csv)[:csv])
    redirect_to cases_path
  end

end