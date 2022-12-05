class StandingsController < ApplicationController
  before_action :set_standing, only: %i[ show edit update destroy ]

  # GET /standings or /standings.json
  def index
    @standings = Standing.all
  end

  # GET /standings/1 or /standings/1.json
  def show
  end

  # GET /standings/new
  def new
    @standing = Standing.new
  end

  # GET /standings/1/edit
  def edit
  end

  # POST /standings or /standings.json
  def create
    @standing = Standing.new(standing_params)

    respond_to do |format|
      if @standing.save
        format.html { redirect_to standing_url(@standing), notice: "Standing was successfully created." }
        format.json { render :show, status: :created, location: @standing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @standing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /standings/1 or /standings/1.json
  def update
    respond_to do |format|
      if @standing.update(standing_params)
        format.html { redirect_to standing_url(@standing), notice: "Standing was successfully updated." }
        format.json { render :show, status: :ok, location: @standing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @standing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /standings/1 or /standings/1.json
  def destroy
    @standing.destroy

    respond_to do |format|
      format.html { redirect_to standings_url, notice: "Standing was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_standing
      @standing = Standing.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def standing_params
      params.require(:standing).permit(:team_id, :wins, :draws, :losses, :goals_for, :goals_against, :points)
    end
end
