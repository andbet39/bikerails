class RideTypesController < ApplicationController
  before_action :set_ride_type, only: [:show, :edit, :update, :destroy]

  # GET /ride_types
  # GET /ride_types.json
  def index
    @ride_types = RideType.all
  end

  # GET /ride_types/1
  # GET /ride_types/1.json
  def show
  end

  # GET /ride_types/new
  def new
    @ride_type = RideType.new
  end

  # GET /ride_types/1/edit
  def edit
  end

  # POST /ride_types
  # POST /ride_types.json
  def create
    @ride_type = RideType.new(ride_type_params)

    respond_to do |format|
      if @ride_type.save
        format.html { redirect_to @ride_type, notice: 'Ride type was successfully created.' }
        format.json { render :show, status: :created, location: @ride_type }
      else
        format.html { render :new }
        format.json { render json: @ride_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ride_types/1
  # PATCH/PUT /ride_types/1.json
  def update
    respond_to do |format|
      if @ride_type.update(ride_type_params)
        format.html { redirect_to @ride_type, notice: 'Ride type was successfully updated.' }
        format.json { render :show, status: :ok, location: @ride_type }
      else
        format.html { render :edit }
        format.json { render json: @ride_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ride_types/1
  # DELETE /ride_types/1.json
  def destroy
    @ride_type.destroy
    respond_to do |format|
      format.html { redirect_to ride_types_url, notice: 'Ride type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ride_type
      @ride_type = RideType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ride_type_params
      params.require(:ride_type).permit(:name, :image, :icon)
    end
end
