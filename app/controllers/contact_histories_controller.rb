class ContactHistoriesController < ApplicationController
  before_action :set_contact_history, only: [:show, :edit, :update, :destroy]

  # GET /contact_histories
  # GET /contact_histories.json
  def index
    @contact_histories = ContactHistory.all
  end

  # GET /contact_histories/1
  # GET /contact_histories/1.json
  def show
  end

  # GET /contact_histories/new
  def new
    @contact_history = ContactHistory.new
  end

  # GET /contact_histories/1/edit
  def edit
  end

  # POST /contact_histories
  # POST /contact_histories.json
  def create
    @contact_history = ContactHistory.new(contact_history_params)

    respond_to do |format|
      if @contact_history.save
        format.html { redirect_to @contact_history, notice: 'Contact history was successfully created.' }
        format.json { render :show, status: :created, location: @contact_history }
      else
        format.html { render :new }
        format.json { render json: @contact_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_histories/1
  # PATCH/PUT /contact_histories/1.json
  def update
    respond_to do |format|
      if @contact_history.update(contact_history_params)
        format.html { redirect_to @contact_history, notice: 'Contact history was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact_history }
      else
        format.html { render :edit }
        format.json { render json: @contact_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_histories/1
  # DELETE /contact_histories/1.json
  def destroy
    @contact_history.destroy
    respond_to do |format|
      format.html { redirect_to contact_histories_url, notice: 'Contact history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact_history
      @contact_history = ContactHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_history_params
      params.require(:contact_history).permit(:contact_history_id, :lookup_id, :type, :date)
    end
end
