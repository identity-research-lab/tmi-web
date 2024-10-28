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
    @codes = @category.codes
  end

  def enqueue_categories
    context = params[:context].gsub("class", "klass")
    CategoryExtractorJob.perform_async(context)
    redirect_to(action: :index, params: {context: context, enqueued_at: Time.now.strftime("%s")})
  end

  def new
    @category = Theme.new
  end

  def create
    @category = Theme.new(category_params)
    success = @category.save
    redirect_to @category
  end

  def destroy
    @category = Theme.find(params[:id])
    @category.destroy
    redirect_to categories_path
  end

  def update
    @category = Theme.find(params[:id])
    new_category_ids = category_params[:categories].split(/[\,\s]/)
    update_kind = @category.categories.length == new_category_ids.length ? "metadata" : "category"

    if category_params[:categories]
      categories = Category.where(id: new_category_ids)
      @category.categories = categories
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

  private

  def category_params
    params.require(:category).permit(:name, :description, :categories)
  end

end
