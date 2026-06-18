class StandingsController < ApplicationController
  before_action :set_standing, only: %i[ show edit update destroy ]

  def index
    @year = params[:year]&.to_i || 2026
    @year = 2026 unless [2022, 2026].include?(@year)
    @current_year = @year
    
    @standings = Standing.joins(:team)
                        .where(teams: { year: @year })
                        .order("teams.group ASC, points DESC,
                        (goals_for - goals_against) DESC, goals_for DESC, teams.ranking ASC")
  end

  def show
  end

  def new
    @standing = Standing.new
  end

  def edit
  end

  def create
    @standing = Standing.new(standing_params)

    respond_to do |format|
      if @standing.save
        format.html { redirect_to @standing, notice: "Standing was successfully created." }
        format.json { render :show, status: :created, location: @standing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @standing.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @standing.update(standing_params)
        format.html { redirect_to @standing, notice: "Standing was successfully updated." }
        format.json { render :show, status: :ok, location: @standing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @standing.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @standing.destroy
    respond_to do |format|
      format.html { redirect_to standings_url, notice: "Standing was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_standing
      @standing = Standing.find(params[:id])
    end

    def standing_params
      params.require(:standing).permit(:team_id, :wins, :draws, :losses, :goals_for, :goals_against, :points)
    end
end
