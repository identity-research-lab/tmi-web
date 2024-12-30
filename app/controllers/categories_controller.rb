class CategoriesController < ApplicationController

  before_action :scope_context

  def show
    @category = Category.find(params[:id])
    @codes = Code.where(context: @category.context).order(:name)
    @context = Context.find_by(name: @category.context)

    category_ids = Category.where(context: @category.context).pluck(:id)
    previous_index = (category_ids.index(@category.id) - 1)
    next_index = (category_ids.index(@category.id) + 1) % category_ids.length
    @previous_category_id = category_ids[previous_index]
    @next_category_id = category_ids[next_index]
  end

  def new
    @category  = Category.new(name: "New Category", context: @context.name)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to context_category_path(@context, @category)
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to context_path(@context)
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
        render turbo_stream: turbo_stream.replace("frame-category", partial: "/categories/form", locals: { category: @category, context: @context, success: success, update_kind: update_kind })
      end
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description, :context, :codes)
  end

  def scope_context
    @context = params[:context_id].present? ? Context.find(params[:context_id]) : Context.new
  end

  def scope_nav
    @nav_context = "categories"
  end

end
