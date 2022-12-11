class FixturesController < ApplicationController
  before_action :set_fixture, only: %i[ show edit update destroy ]

  # GET /fixtures or /fixtures.json
  def index
    @fixtures = Fixture.joins(:session).order("date DESC, time DESC")
  end

 def list_fixtures
    @fixtures = Fixture.left_joins(:criterium).where("fixtures.date >= criteria.show_date")
  end

  # GET /fixtures/1 or /fixtures/1.json
  def show
  end

  # GET /fixtures/new
  def new
    @fixture = Fixture.new
  end

  # GET /fixtures/1/edit
  def edit
  end

  # POST /fixtures or /fixtures.json
  def create
    @fixture = Fixture.new(fixture_params)

    respond_to do |format|
      if @fixture.save
        format.html { redirect_to fixture_url(@fixture), notice: "Fixture was successfully created." }
        format.json { render :show, status: :created, location: @fixture }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fixture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fixtures/1 or /fixtures/1.json
  def update
    respond_to do |format|
      if @fixture.update(fixture_params)
        format.html { redirect_to fixture_url(@fixture), notice: "Fixture was successfully updated." }
        format.json { render :show, status: :ok, location: @fixture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fixture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fixtures/1 or /fixtures/1.json
  def destroy
    @fixture.destroy

    respond_to do |format|
      format.html { redirect_to fixtures_url, notice: "Fixture was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fixture
      @fixture = Fixture.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fixture_params
      params.require(:fixture).permit(:round_id, :date, :session_id, :home_id, :channel_id, :away_id)
    end
end
