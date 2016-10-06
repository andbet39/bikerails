class RideLevelsController < ApplicationController
  before_action :set_ride_level, only: [:show, :edit, :update, :destroy]

  # GET /ride_levels
  # GET /ride_levels.json
  def index
    @ride_levels = RideLevel.all
  end

  # GET /ride_levels/1
  # GET /ride_levels/1.json
  def show
  end

  # GET /ride_levels/new
  def new
    @ride_level = RideLevel.new
  end

  # GET /ride_levels/1/edit
  def edit
  end

  # POST /ride_levels
  # POST /ride_levels.json
  def create
    @ride_level = RideLevel.new(ride_level_params)

    respond_to do |format|
      if @ride_level.save
        format.html { redirect_to @ride_level, notice: 'Ride level was successfully created.' }
        format.json { render :show, status: :created, location: @ride_level }
      else
        format.html { render :new }
        format.json { render json: @ride_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ride_levels/1
  # PATCH/PUT /ride_levels/1.json
  def update
    respond_to do |format|
      if @ride_level.update(ride_level_params)
        format.html { redirect_to @ride_level, notice: 'Ride level was successfully updated.' }
        format.json { render :show, status: :ok, location: @ride_level }
      else
        format.html { render :edit }
        format.json { render json: @ride_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ride_levels/1
  # DELETE /ride_levels/1.json
  def destroy
    @ride_level.destroy
    respond_to do |format|
      format.html { redirect_to ride_levels_url, notice: 'Ride level was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ride_level
      @ride_level = RideLevel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ride_level_params
      params.require(:ride_level).permit(:name, :val)
    end
end
