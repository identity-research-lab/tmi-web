class ThemesController < ApplicationController

  def index
    @contexts = Theme::CONTEXTS
  end

  def show
    @context = params[:id]
    @context_name = Theme::CONTEXTS[params[:id]]
    @themes = Theme.where(context: @context)
    @categories = Category.where(context: @context)
    @codes = Code.where(context: @context)
  end

  def create
    @theme = Theme.new(theme_params)
    success = @theme.save
    redirect_to action: :show, id: @theme.context
  end

  def update
    @theme = Theme.find(params[:id])

    categories = Category.where(id: params[:theme][:categories].split(','))
    @theme.categories = categories
    @theme.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("frame-theme-#{@theme.id}", partial: "/themes/form", locals: { theme: @theme  })
      end
    end
  end

  private

  def theme_params
    params.require(:theme).permit(:name, :context)
  end

end
