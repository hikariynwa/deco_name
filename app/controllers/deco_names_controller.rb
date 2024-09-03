class DecoNamesController < ApplicationController
  before_action :set_deco_name, only: %i[ show edit update destroy ]

  # GET /deco_names or /deco_names.json
  def index
    @deco_names = DecoName.all
  end

  # GET /deco_names/1 or /deco_names/1.json
  def show
  end

  # GET /deco_names/new
  def new
    @deco_name = DecoName.new
  end

  # GET /deco_names/1/edit
  def edit
  end

  # POST /deco_names or /deco_names.json
  def create
    @deco_name = DecoName.new(deco_name_params)

    respond_to do |format|
      if @deco_name.save
        # デコレーションされた名前が描かれた画像を表示するための処理
        format.html { redirect_to @deco_name, notice: "Deco name was successfully created." }
        format.json { render :show, status: :created, location: @deco_name }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deco_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deco_names/1 or /deco_names/1.json
  def update
    respond_to do |format|
      if @deco_name.update(deco_name_params)
        format.html { redirect_to deco_name_url(@deco_name), notice: "Deco name was successfully updated." }
        format.json { render :show, status: :ok, location: @deco_name }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deco_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deco_names/1 or /deco_names/1.json
  def destroy
    @deco_name.destroy!

    respond_to do |format|
      format.html { redirect_to deco_names_url, notice: "Deco name was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deco_name
      @deco_name = DecoName.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def deco_name_params
      params.require(:deco_name).permit(:name)
    end
end
