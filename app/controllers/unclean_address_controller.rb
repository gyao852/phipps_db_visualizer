class UncleanAddressController < ApplicationController

	def create
    @unclean_address = UncleanAddress.new(unclean_address_params)

    respond_to do |format|
      if @unclean_address.save
        format.html { redirect_to @unclean_address, notice: 'Address was successfully created.' }
        format.json { render :show, status: :created, location: @unclean_address }
      else
        format.html { render :new }
        format.json { render json: @unclean_address.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @unclean_address.update(unclean_address_params)
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @unclean_address }
      else
        format.html { render :edit }
        format.json { render json: @unclean_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @unclean_address.destroy
    respond_to do |format|
      format.html { redirect_to unclean_addresses_url, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @unclean_address = UncleanAddress.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unclean_address_params
      params.require(:unclean_address).permit(:address_id, :lookup_id, :address_1, :city, :state, :zip, :country, :address_type, :date_added,:errors)
    end
end
