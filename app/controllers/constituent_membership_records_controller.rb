class ConstituentMembershipRecordsController < ApplicationController
  before_action :set_constituent_membership_record, only: [:show, :edit, :update, :destroy]

  # GET /constituent_membership_records
  # GET /constituent_membership_records.json
  def index
    @constituent_membership_records = ConstituentMembershipRecord.all
    @nav_status = 'db'
  end

  # GET /constituent_membership_records/1
  # GET /constituent_membership_records/1.json
  def show
    @nav_status = 'db'
  end

  # GET /constituent_membership_records/new
  def new
    @constituent_membership_record = ConstituentMembershipRecord.new
  end

  # GET /constituent_membership_records/1/edit
  def edit
  end

  # POST /constituent_membership_records
  # POST /constituent_membership_records.json
  def create
    @constituent_membership_record = ConstituentMembershipRecord.new(constituent_membership_record_params)

    respond_to do |format|
      if @constituent_membership_record.save
        format.html { redirect_to @constituent_membership_record, notice: 'Constituent membership record was successfully created.' }
        format.json { render :show, status: :created, location: @constituent_membership_record }
      else
        format.html { render :new }
        format.json { render json: @constituent_membership_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /constituent_membership_records/1
  # PATCH/PUT /constituent_membership_records/1.json
  def update
    respond_to do |format|
      if @constituent_membership_record.update(constituent_membership_record_params)
        format.html { redirect_to @constituent_membership_record, notice: 'Constituent membership record was successfully updated.' }
        format.json { render :show, status: :ok, location: @constituent_membership_record }
      else
        format.html { render :edit }
        format.json { render json: @constituent_membership_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /constituent_membership_records/1
  # DELETE /constituent_membership_records/1.json
  def destroy
    @constituent_membership_record.destroy
    respond_to do |format|
      format.html { redirect_to constituent_membership_records_url, notice: 'Constituent membership record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import
    ConstituentMembershipRecord.import(params[:file])
    redirect_to constituent_membership_records_path, notice: "csv imported"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_constituent_membership_record
      @constituent_membership_record = ConstituentMembershipRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def constituent_membership_record_params
      params.require(:constituent_membership_record).permit(:lookup_id, :membership_id)
    end
end
