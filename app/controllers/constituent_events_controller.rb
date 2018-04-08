class ConstituentEventsController < ApplicationController
  before_action :set_constituent_event, only: [:show, :edit, :update, :destroy]

  # GET /constituent_events
  # GET /constituent_events.json
  def index
    @nav_status = 'db'
    @constituent_events = ConstituentEvent.all
  end

  # GET /constituent_events/1
  # GET /constituent_events/1.json
  def show
    @nav_status = 'db'
  end

  # GET /constituent_events/new
  def new
    @constituent_event = ConstituentEvent.new
  end

  # GET /constituent_events/1/edit
  def edit
  end

  # POST /constituent_events
  # POST /constituent_events.json
  def create
    @constituent_event = ConstituentEvent.new(constituent_event_params)

    respond_to do |format|
      if @constituent_event.save
        format.html { redirect_to @constituent_event, notice: 'Constituent event was successfully created.' }
        format.json { render :show, status: :created, location: @constituent_event }
      else
        format.html { render :new }
        format.json { render json: @constituent_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /constituent_events/1
  # PATCH/PUT /constituent_events/1.json
  def update
    respond_to do |format|
      if @constituent_event.update(constituent_event_params)
        format.html { redirect_to @constituent_event, notice: 'Constituent event was successfully updated.' }
        format.json { render :show, status: :ok, location: @constituent_event }
      else
        format.html { render :edit }
        format.json { render json: @constituent_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /constituent_events/1
  # DELETE /constituent_events/1.json
  def destroy
    @constituent_event.destroy
    respond_to do |format|
      format.html { redirect_to constituent_events_url, notice: 'Constituent event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import
    ConstituentEvent.import(params[:file])
    redirect_to constituent_events_path, notice: "csv imported"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_constituent_event
      @constituent_event = ConstituentEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def constituent_event_params
      params.require(:constituent_event).permit(:lookup_id, :event_id, :status, :attend, :host_name)
    end
end
