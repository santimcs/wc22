class FixturesController < ApplicationController
  before_action :set_fixture, only: %i[ show edit update destroy ]
  before_action :set_year, only: %i[ index list_fixtures new create edit update ]

  # GET /fixtures
  def index
    @fixtures = Fixture.joins(:session)
                       .where(year: @year)
                       .order("date ASC, sessions.sequence ASC")
    @current_year = @year
  end

  # GET /fixtures/1
  def show
    @current_year = @fixture.year
  end

  # GET /fixtures/new
  def new
    @year = params[:year]&.to_i || 2026
    @year = 2026 unless [2022, 2026].include?(@year)
    @fixture = Fixture.new(year: @year)
    @teams = Team.where(year: @year).order(:group, :name)
  end

  # GET /fixtures/1/edit
  def edit
    @year = @fixture.year
    @teams = Team.where(year: @year).order(:group, :name)
  end

  # POST /fixtures
  def create
    @fixture = Fixture.new(fixture_params)
    @teams = Team.where(year: @fixture.year).order(:group, :name)

    respond_to do |format|
      if @fixture.save
        format.html { redirect_to @fixture, notice: "Fixture was successfully created." }
        format.json { render :show, status: :created, location: @fixture }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fixture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fixtures/1
  def update
    @year = @fixture.year
    @teams = Team.where(year: @year).order(:group, :name)
    
    respond_to do |format|
      if @fixture.update(fixture_params)
        format.html { redirect_to @fixture, notice: "Fixture was successfully updated." }
        format.json { render :show, status: :ok, location: @fixture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fixture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fixtures/1
  def destroy
    @fixture.destroy
    respond_to do |format|
      format.html { redirect_to fixtures_url, notice: "Fixture was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /list_fixtures
  def list_fixtures
    @fixtures = Fixture.left_joins(:criterium)
                       .joins(:session)
                       .where(year: @year)
                       .where("fixtures.date >= criteria.show_date")
                       .order("date ASC, sessions.sequence ASC")
    @current_year = @year
  end

  private

  def set_fixture
    @fixture = Fixture.find(params[:id])
  end

  def set_year
    @year = params[:year]&.to_i || 2026
    @year = 2026 unless [2022, 2026].include?(@year)
  end

  def fixture_params
    params.require(:fixture).permit(:round_id, :date, :session_id, :home_id, :away_id, :channel_id, :criterium_id, :year)
  end
end
