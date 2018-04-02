class DonationProgramsController < ApplicationController
  before_action :set_donation_program, only: [:show, :edit, :update, :destroy]

  # GET /donation_programs
  # GET /donation_programs.json
  def index
    @nav_status = 'db'
    @donation_programs = DonationProgram.all
  end

  # GET /donation_programs/1
  # GET /donation_programs/1.json
  def show
    @nav_status = 'db'
  end

  # GET /donation_programs/new
  def new
    @donation_program = DonationProgram.new
  end

  # GET /donation_programs/1/edit
  def edit
  end

  # POST /donation_programs
  # POST /donation_programs.json
  def create
    @donation_program = DonationProgram.new(donation_program_params)

    respond_to do |format|
      if @donation_program.save
        format.html { redirect_to @donation_program, notice: 'Donation program was successfully created.' }
        format.json { render :show, status: :created, location: @donation_program }
      else
        format.html { render :new }
        format.json { render json: @donation_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /donation_programs/1
  # PATCH/PUT /donation_programs/1.json
  def update
    respond_to do |format|
      if @donation_program.update(donation_program_params)
        format.html { redirect_to @donation_program, notice: 'Donation program was successfully updated.' }
        format.json { render :show, status: :ok, location: @donation_program }
      else
        format.html { render :edit }
        format.json { render json: @donation_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /donation_programs/1
  # DELETE /donation_programs/1.json
  def destroy
    @donation_program.destroy
    respond_to do |format|
      format.html { redirect_to donation_programs_url, notice: 'Donation program was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation_program
      @donation_program = DonationProgram.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def donation_program_params
      params.require(:donation_program).permit(:donation_program_id, :program, :active)
    end
end
