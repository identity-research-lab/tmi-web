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

    categories = Category.where(id: theme_params[:categories].split(','))
    @theme.categories = categories
    @theme.name = theme_params[:name]
    @theme.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("frame-theme", partial: "/themes/form", locals: { theme: @theme  })
      end
    end
  end

  private

  def theme_params
    params.require(:theme).permit(:name, :description, :notes, :categories)
  end

end
