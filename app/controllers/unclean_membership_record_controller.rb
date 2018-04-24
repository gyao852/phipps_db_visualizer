class UncleanMembershipRecordController < ApplicationController
	def create
    @unclean_membership_record = UncleanMembershipRecord.new(unclean_membership_record_params)

    respond_to do |format|
      if @unclean_membership_record.save
        format.html { redirect_to @unclean_membership_record, notice: 'Membership record was successfully created.' }
        format.json { render :show, status: :created, location: @unclean_membership_record }
      else
        format.html { render :new }
        format.json { render json: @unclean_membership_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /membership_records/1
  # PATCH/PUT /membership_records/1.json
  def update
    respond_to do |format|
      if @unclean_membership_record.update(unclean_membership_record_params)
        format.html { redirect_to @unclean_membership_record, notice: 'Membership record was successfully updated.' }
        format.json { render :show, status: :ok, location: @unclean_membership_record }
      else
        format.html { render :edit }
        format.json { render json: @unclean_membership_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /membership_records/1
  # DELETE /membership_records/1.json
  def destroy
    @unclean_membership_record.destroy
    respond_to do |format|
      format.html { redirect_to unclean_membership_records_url, notice: 'Membership record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import
    UncleanMembershipRecord.import(params[:file])
    redirect_to unclean_membership_records_path, notice: "csv imported"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership_record
      @unclean_membership_record = UncleanMembershipRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unclean_membership_record_params
      params.require(:unclean_membership_record).permit(:membership_id,:lookup_id, :membership_scheme, :membership_level, :add_ons, :membership_level_type, :membership_status, :membership_term, :start_date, :end_date, :last_renewed,:errors)
    end
end
