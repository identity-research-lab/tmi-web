class CategoriesController < ApplicationController

  before_action :scope_question

  def index
    @section_name = @question.label
    @context = @question.context
    @categories = Category.where(context: @question.context.name).order(:name)
    @enqueued_at = params[:enqueued_at].present? ? Time.at(params[:enqueued_at].to_i).strftime("%T %Z") : nil
  end

  def show
    @category = Category.find(params[:id])
    @codes = Code.where(context: @category.context).order(:name)
  end

  def new
    @category  = Category.new(name: "New Category", context: @question.context.name)
    @context = @question.context
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to question_category_path(@question, @category)
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to question_categories_path(@question)
  end

  def update
    @category = Category.find(params[:id])
    new_code_ids = category_params[:codes].split(/[\,\s]/)
    update_kind = @category.codes.length == new_code_ids.length ? "metadata" : "category"

    if category_params[:codes]
      codes = Code.where(id: new_code_ids)
      @category.codes = codes
    end

    @category.name = category_params[:name]
    @category.description = category_params[:description]
    update_kind ||= "metadata"
    success = @category.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("frame-category", partial: "/categories/form", locals: { category: @category, question: @question, success: success, update_kind: update_kind })
      end
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description, :context, :codes)
  end

  def scope_question
    @question = Question.find(params[:question_id])
  end

end
