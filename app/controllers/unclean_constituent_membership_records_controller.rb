class UncleanConstituentMembershipRecordsController < ApplicationController

	def create
    @unclean_constituent_membership_record = UncleanConstituentMembershipRecord.new(unclean_constituent_membership_record_params)

    respond_to do |format|
      if @unclean_constituent_membership_record.save
        format.html { redirect_to @unclean_constituent_membership_record, notice: 'Constituent membership record was successfully created.' }
        format.json { render :show, status: :created, location: @unclean_constituent_membership_record }
      else
        format.html { render :new }
        format.json { render json: @unclean_constituent_membership_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /constituent_membership_records/1
  # PATCH/PUT /constituent_membership_records/1.json
  def update
    respond_to do |format|
      if @unclean_constituent_membership_record.update(unclean_constituent_membership_record_params)
        format.html { redirect_to @unclean_constituent_membership_record, notice: 'Constituent membership record was successfully updated.' }
        format.json { render :show, status: :ok, location: @unclean_constituent_membership_record }
      else
        format.html { render :edit }
        format.json { render json: @unclean_constituent_membership_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /constituent_membership_records/1
  # DELETE /constituent_membership_records/1.json
  def destroy
    @unclean_constituent_membership_record.destroy
    respond_to do |format|
      format.html { redirect_to unclean_constituent_membership_records_url, notice: 'Constituent membership record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import
    UncleanConstituentMembershipRecord.import(params[:file])
    redirect_to unclean_constituent_membership_records_path, notice: "csv imported"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_constituent_membership_record
      @unclean_constituent_membership_record = UncleanConstituentMembershipRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unclean_constituent_membership_record_params
      params.require(:unclean_constituent_membership_record).permit(:lookup_id, :membership_id,:errors)
    end
end
