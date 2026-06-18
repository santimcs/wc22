class ResultsController < ApplicationController
  before_action :set_result, only: %i[ show edit update destroy ]
  before_action :set_year, only: %i[ index ]

  def index
    @year = params[:year]&.to_i || 2026
    @year = 2026 unless [2022, 2026].include?(@year)
    @current_year = @year
    
    @results = Result.joins(:fixture)
                     .where(fixtures: { year: @year })
                     .order("fixtures.date DESC, fixtures.session_id DESC")
  end

  def new
    @result = Result.new
    @result.fixture_id = params[:fixture_id] if params[:fixture_id].present?
    
    if @result.fixture_id.present?
      @fixture = Fixture.find(@result.fixture_id)
      @result.year = @fixture.year
    end
  end

  def create
    @result = Result.new(result_params)
    @result.year = @result.fixture.year

    respond_to do |format|
      if @result.save
        format.html { redirect_to results_path(year: @result.year), notice: "Result was successfully created." }
        format.json { render :show, status: :created, location: @result }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @result.update(result_params)
        format.html { redirect_to results_path(year: @result.year), notice: "Result was successfully updated." }
        format.json { render :show, status: :ok, location: @result }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    year = @result.year
    @result.destroy
    respond_to do |format|
      format.html { redirect_to results_path(year: year), notice: "Result was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  
  def set_result
    @result = Result.find(params[:id])
  end

  def set_year
    @year = params[:year]&.to_i || 2026
    @year = 2026 unless [2022, 2026].include?(@year)
  end

  def result_params
    params.require(:result).permit(:fixture_id, :home_goals, :away_goals, :year)
  end
end
