class UncleanConstituentEventsController < ApplicationController
	def create
    @unclean_constituent_event = UncleanConstituentEvent.new(unclean_constituent_event_params)

    respond_to do |format|
      if @unclean_constituent_event.save
        format.html { redirect_to @unclean_constituent_event, notice: 'Constituent event was successfully created.' }
        format.json { render :show, status: :created, location: @unclean_constituent_event }
      else
        format.html { render :new }
        format.json { render json: @unclean_constituent_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /constituent_events/1
  # PATCH/PUT /constituent_events/1.json
  def update
    respond_to do |format|
      if @unclean_constituent_event.update(unclean_constituent_event_params)
        format.html { redirect_to @unclean_constituent_event, notice: 'Constituent event was successfully updated.' }
        format.json { render :show, status: :ok, location: @unclean_constituent_event }
      else
        format.html { render :edit }
        format.json { render json: @unclean_constituent_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /constituent_events/1
  # DELETE /constituent_events/1.json
  def destroy
    @unclean_constituent_event.destroy
    respond_to do |format|
      format.html { redirect_to unclean_constituent_events_url, notice: 'Constituent event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import
    UncleanConstituentEvent.import(params[:file])
    redirect_to constituent_events_path, notice: "csv imported"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_constituent_event
      @unclean_constituent_event = UncleanConstituentEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unclean_constituent_event_params
      params.require(:unclean_constituent_event).permit(:lookup_id, :event_id, :status, :attend, :host_name,:errors)
    end
end
