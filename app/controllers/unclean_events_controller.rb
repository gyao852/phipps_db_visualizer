class UncleanEventsController < ApplicationController

	def create
    @unclean_event = UncleanEvent.new(unclean_event_params)

    respond_to do |format|
      if @unclean_event.save
        format.html { redirect_to @unclean_event, notice: 'UncleanEvent was successfully created.' }
        format.json { render :show, status: :created, location: @unclean_event }
      else
        format.html { render :new }
        format.json { render json: @unclean_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @unclean_event.update(unclean_event_params)
        format.html { redirect_to @unclean_event, notice: 'UncleanEvent was successfully updated.' }
        format.json { render :show, status: :ok, location: @unclean_event }
      else
        format.html { render :edit }
        format.json { render json: @unclean_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @unclean_event.destroy
    respond_to do |format|
      format.html { redirect_to unclean_events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import
    UncleanEvent.import(params[:file])
    redirect_to unclean_events_path, notice: "csv imported"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @unclean_event = UncleanEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unclean_event_params
      params.require(:unclean_event).permit(:event_id, :event_name, :category, :start_date_time, :end_date_time, :errors)
    end
end
