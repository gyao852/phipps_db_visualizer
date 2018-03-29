class DonationHistoriesController < ApplicationController
  before_action :set_donation_history, only: [:show, :edit, :update, :destroy]

  # GET /donation_histories
  # GET /donation_histories.json
  def index
    @donation_histories = DonationHistory.all
  end

  # GET /donation_histories/1
  # GET /donation_histories/1.json
  def show
  end

  # GET /donation_histories/new
  def new
    @donation_history = DonationHistory.new
  end

  # GET /donation_histories/1/edit
  def edit
  end

  # POST /donation_histories
  # POST /donation_histories.json
  def create
    @donation_history = DonationHistory.new(donation_history_params)

    respond_to do |format|
      if @donation_history.save
        format.html { redirect_to @donation_history, notice: 'Donation history was successfully created.' }
        format.json { render :show, status: :created, location: @donation_history }
      else
        format.html { render :new }
        format.json { render json: @donation_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /donation_histories/1
  # PATCH/PUT /donation_histories/1.json
  def update
    respond_to do |format|
      if @donation_history.update(donation_history_params)
        format.html { redirect_to @donation_history, notice: 'Donation history was successfully updated.' }
        format.json { render :show, status: :ok, location: @donation_history }
      else
        format.html { render :edit }
        format.json { render json: @donation_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /donation_histories/1
  # DELETE /donation_histories/1.json
  def destroy
    @donation_history.destroy
    respond_to do |format|
      format.html { redirect_to donation_histories_url, notice: 'Donation history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation_history
      @donation_history = DonationHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def donation_history_params
      params.require(:donation_history).permit(:donation_history_id, :lookup_id, :amount, :date, :method, :do_not_acknowledge, :given_anonymously, :transaction_type)
    end
end
