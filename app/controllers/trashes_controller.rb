class TrashesController < ApplicationController
  before_action :set_trash, only: %i[ show edit update destroy ]

  # GET /trashes
  def index
    @trashes = Trash.all
  end

  # GET /trashes/1
  def show
  end

  # GET /trashes/new
  def new
    @trash = Trash.new
  end

  # GET /trashes/1/edit
  def edit
  end

  # POST /trashes
  def create
    @trash = Trash.new(trash_params)

    if @trash.save
      redirect_to @trash, notice: "Trash was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trashes/1
  def update
    if @trash.update(trash_params)
      redirect_to @trash, notice: "Trash was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /trashes/1
  def destroy
    @trash.destroy!
    redirect_to trashes_url, notice: "Trash was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trash
      @trash = Trash.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trash_params
      params.require(:trash).permit(:name)
    end
end
