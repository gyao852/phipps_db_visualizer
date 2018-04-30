class UncleanConstituentsController < ApplicationController
	before_action :set_constituent, only: [:show]

  # GET /constituents
  # GET /constituents.json
  def index
    @nav_status = 'review'
    @unclean_constituents = UncleanConstituent.all.paginate(:page => params[:page], :per_page => 30)
    @invalid = UncleanConstituent.invalid
    
  end

  def index_invalid_emails
    @nav_status = 'review'
    @unclean_constituents = UncleanConstituent.invalid_emails
  end

  def index_invalid_phones
    @nav_status = 'review'
    @unclean_constituents = UncleanConstituent.invalid_phones
  end

  def index_invalid_zips
    @nav_status = 'review'
    @unclean_constituents = UncleanConstituent.invalid_zips
  end


  # GET /constituents/1
  # GET /constituents/1.json
  def show
    @nav_status = 'review'
  end

  # GET /constituents/new
  def new
    @nav_status = 'review'
    @unclean_constituents = UncleanConstituent.new
  end

  # GET /constituents/1/edit
  def edit
    @nav_status = 'review'
  end

  # POST /constituents
  # POST /constituents.json
  def create
    @nav_status = 'review'
    @unclean_constituents = UncleanConstituent.new(unclean_constituent_params)

    respond_to do |format|
      if @unclean_constituents.save
        format.html { redirect_to @unclean_constituents, notice: 'Constituent was successfully created.' }
        format.json { render :show, status: :created, location: @unclean_constituents }
      else
        format.html { render :new }
        format.json { render json: @unclean_constituents.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /constituents/1
  # PATCH/PUT /constituents/1.json
  def update
    @nav_status = 'review'
    respond_to do |format|
      if @unclean_constituents.update(unclean_constituent_params)
        format.html { redirect_to @unclean_constituents, notice: 'Constituent was successfully updated.' }
        format.json { render :show, status: :ok, location: @unclean_constituents }
      else
        format.html { render :edit }
        format.json { render json: @unclean_constituents.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /constituents/1
  # DELETE /constituents/1.json
  def destroy
    @unclean_constituents.destroy
    respond_to do |format|
      format.html { redirect_to unclean_constituents_url, notice: 'Constituent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # def import
  #   Constituent.import(params[:file])
  #   redirect_to constituents_path, notice: "csv imported"
  # end



  def import_page
    @nav_status = 'import_page'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_constituent
      @unclean_constituent = UncleanConstituent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unclean_constituent_params
      params.require(:unclean_constituent).permit(:lookup_id, :suffix, :title, :name, :last_group, :email_id, :phone, :dob, :do_not_email, :duplicate,
        :incomplete_names,:invalid_emails,:invalid_phones,:invalid_zips,:no_contact,:duplicate,:duplicate_lookup_ids)
    end
end
