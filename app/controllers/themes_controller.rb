class ThemesController < ApplicationController

  def index
    @themes = Theme.all.order(&:name)
  end

  def new
    @theme = Theme.new
  end

  def show
    @contexts = Context.all.order(:name)
    @theme = Theme.find(params[:id])
    @categories = Category.all
    
    theme_ids = Theme.all.order(:name).pluck(:id)
    previous_index = (theme_ids.index(@theme.id) - 1)
    next_index = (theme_ids.index(@theme.id) + 1) % theme_ids.length
    @previous_theme_id = theme_ids[previous_index]
    @next_theme_id = theme_ids[next_index]
    
  end

  def create
    @theme = Theme.new(theme_params)
    success = @theme.save
    redirect_to @theme
  end

  def destroy
    @theme = Theme.find(params[:id])
    @theme.destroy
    redirect_to themes_path
  end

  def update
    @theme = Theme.find(params[:id])
    new_category_ids = theme_params[:categories].split(/[\,\s]/)
    update_kind = @theme.categories.length == new_category_ids.length ? "metadata" : "category"

    if theme_params[:categories]
      categories = Category.where(id: new_category_ids)
      @theme.categories = categories
    end

    @theme.name = theme_params[:name]
    @theme.description = theme_params[:description]
    update_kind ||= "metadata"
    success = @theme.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("frame-theme", partial: "/themes/form", locals: { theme: @theme, success: success, update_kind: update_kind })
      end
    end
  end

  private

  def theme_params
    params.require(:theme).permit(:name, :description, :notes, :categories)
  end

end
