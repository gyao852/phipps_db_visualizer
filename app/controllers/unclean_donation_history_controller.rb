class UncleanUncleanDonationHistoryController < ApplicationController
	def create
    puts params
    @unclean_donation_history = UncleanDonationHistory.new(unclean_donation_history_params)

    respond_to do |format|
      if @unclean_donation_history.save
        format.html { redirect_to @unclean_donation_history, notice: 'Donation history was successfully created.' }
        format.json { render :show, status: :created, location: @unclean_donation_history }
      else
        format.html { render :new }
        format.json { render json: @unclean_donation_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /donation_histories/1
  # PATCH/PUT /donation_histories/1.json
  def update
    respond_to do |format|
      if @unclean_donation_history.update(unclean_donation_history_params)
        format.html { redirect_to @unclean_donation_history, notice: 'Donation history was successfully updated.' }
        format.json { render :show, status: :ok, location: @unclean_donation_history }
      else
        format.html { render :edit }
        format.json { render json: @unclean_donation_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /donation_histories/1
  # DELETE /donation_histories/1.json
  def destroy
    @unclean_donation_history.destroy
    respond_to do |format|
      format.html { redirect_to unclean_donation_histories_url, notice: 'Donation history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unclean_donation_history
      @unclean_donation_history = UncleanDonationHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unclean_donation_history_params
      params.require(:unclean_donation_history).permit(:unclean_donation_history_id, :donation_program_id, :lookup_id, :amount, :date, :payment_method, :do_not_acknowledge, :given_anonymously, :transaction_type, :errors)
    end
end
