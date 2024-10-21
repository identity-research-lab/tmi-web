class ThemesController < ApplicationController

  def index
    @themes = Theme.all.order(&:name)
  end

  def show
    @contexts = Theme::CONTEXTS
    @theme = Theme.find(params[:id])
    @categories = Category.all
  end

  def create
    @theme = Theme.new(theme_params)
    success = @theme.save
    redirect_to action: :show, id: @theme.context
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
    @theme.notes = theme_params[:notes]
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
