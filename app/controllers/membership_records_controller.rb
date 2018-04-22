class MembershipRecordsController < ApplicationController
  before_action :set_membership_record, only: [:show, :edit, :update, :destroy]

  # GET /membership_records
  # GET /membership_records.json
  def index
    @nav_status = 'db'
    @membership_records = MembershipRecord.all
  end

  # GET /membership_records/1
  # GET /membership_records/1.json
  def show
    @nav_status = 'db'
  end

  # GET /membership_records/new
  def new
    @membership_record = MembershipRecord.new
  end

  # GET /membership_records/1/edit
  def edit
  end

  # POST /membership_records
  # POST /membership_records.json
  def create
    @membership_record = MembershipRecord.new(membership_record_params)

    respond_to do |format|
      if @membership_record.save
        format.html { redirect_to @membership_record, notice: 'Membership record was successfully created.' }
        format.json { render :show, status: :created, location: @membership_record }
      else
        format.html { render :new }
        format.json { render json: @membership_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /membership_records/1
  # PATCH/PUT /membership_records/1.json
  def update
    respond_to do |format|
      if @membership_record.update(membership_record_params)
        format.html { redirect_to @membership_record, notice: 'Membership record was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership_record }
      else
        format.html { render :edit }
        format.json { render json: @membership_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /membership_records/1
  # DELETE /membership_records/1.json
  def destroy
    @membership_record.destroy
    respond_to do |format|
      format.html { redirect_to membership_records_url, notice: 'Membership record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import
    MembershipRecord.import(params[:file])
    redirect_to membership_records_path, notice: "csv imported"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership_record
      @membership_record = MembershipRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_record_params
      params.require(:membership_record).permit(:membership_id, :membership_scheme, :membership_level, :add_ons, :membership_level_type, :membership_status, :start_date, :end_date, :last_renewed)
    end
end
