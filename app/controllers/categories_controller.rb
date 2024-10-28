class CategoriesController < ApplicationController

  def index
    @context = params[:context].gsub("class", "klass")
    @question = Question.from(@context)
    @context_key = @question.context
    @section_name = @question.label
    @categories = Category.where(context: @context_key)
    @enqueued_at = params[:enqueued_at].present? ? Time.at(params[:enqueued_at].to_i).strftime("%T %Z") : nil
  end

  def edit
    @category = params[:id] == "uncategorized" ? Category.new(context: params[:context]) : Category.find(params[:id])
    @codes = Code.where(context: @category.context).order(:name)
  end

  def new
    @category = Category.new(context: params[:context])
  end

  def create
    @category = Category.new(category_params)
    success = @category.save
    redirect_to @category
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path
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
        render turbo_stream: turbo_stream.replace("frame-category", partial: "/categories/form", locals: { category: @category, success: success, update_kind: update_kind })
      end
    end
  end

  def enqueue_categories
    context = params[:context].gsub("class", "klass")
    CategoryExtractorJob.perform_async(context)
    redirect_to(action: :index, params: {context: context, enqueued_at: Time.now.strftime("%s")})
  end

  private

  def category_params
    params.require(:category).permit(:name, :description, :codes)
  end

end
