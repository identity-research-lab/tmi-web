class CategoriesController < ApplicationController

  before_action :scope_dimension

  def show
    @category = Category.find(params[:id])
    @codes = Code.where(dimension: @category.dimension).order(:name)
    @dimension = Dimension.find_by(name: @category.dimension)

    category_ids = Category.where(dimension: @category.dimension).pluck(:id)
    previous_index = (category_ids.index(@category.id) - 1)
    next_index = (category_ids.index(@category.id) + 1) % category_ids.length
    @previous_category_id = category_ids[previous_index]
    @next_category_id = category_ids[next_index]
  end

  def new
    @category  = Category.new(name: "New Category", dimension: @dimension.name)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to dimension_category_path(@dimension, @category)
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to dimension_path(@dimension)
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
        render turbo_stream: turbo_stream.replace("frame-category", partial: "/categories/form", locals: { category: @category, dimension: @dimension, success: success, update_kind: update_kind })
      end
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description, :dimension, :codes)
  end

  def scope_dimension
    @dimension = params[:dimension_id].present? ? Dimension.find(params[:dimension_id]) : Dimension.new
  end

  def scope_nav
    @nav_context = "categories"
  end

end
