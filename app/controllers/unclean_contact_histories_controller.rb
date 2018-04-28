class UncleanContactHistoriesController < ApplicationController
	def create
    @unclean_contact_history = UncleanContactHistory.new(unclean_contact_history_params)

    respond_to do |format|
      if @unclean_contact_history.save
        format.html { redirect_to @unclean_contact_history, notice: 'Contact history was successfully created.' }
        format.json { render :show, status: :created, location: @unclean_contact_history }
      else
        format.html { render :new }
        format.json { render json: @unclean_contact_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_histories/1
  # PATCH/PUT /contact_histories/1.json
  def update
    respond_to do |format|
      if @unclean_contact_history.update(unclean_contact_history_params)
        format.html { redirect_to @unclean_contact_history, notice: 'Contact history was successfully updated.' }
        format.json { render :show, status: :ok, location: @unclean_contact_history }
      else
        format.html { render :edit }
        format.json { render json: @unclean_contact_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_histories/1
  # DELETE /contact_histories/1.json
  def destroy
    @unclean_contact_history.destroy
    respond_to do |format|
      format.html { redirect_to contact_histories_url, notice: 'Contact history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import
    UncleanContactHistory.import(params[:file])
    redirect_to unclean_contact_histories_path, notice: "csv imported"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact_history
      @unclean_contact_history = UncleanContactHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unclean_contact_history_params
      params.require(:unclean_contact_history).permit(:lookup_id, :contact_type, :date,:errors)
    end
end
