class UncleanConstituentController < ApplicationController
	before_action :set_constituent, only: [:show]

  # GET /constituents
  # GET /constituents.json
  def index
    @nav_status = 'db'
    @unclean_constituents = UncleanConstituent.all
  end

  # GET /constituents/1
  # GET /constituents/1.json
  def show
    @nav_status = 'db'
  end

  # GET /constituents/new
  def new
    @nav_status = 'db'
    @unclean_constituents = UncleanConstituent.new
  end

  # GET /constituents/1/edit
  def edit
    @nav_status = 'db'
  end

  # POST /constituents
  # POST /constituents.json
  def create
    @nav_status = 'db'
    @unclean_constituents = UncleanConstituent.new(constituent_params)

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
    @nav_status = 'db'
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

  def importfile
    UncleanConstituent.import_file(params[:file])
    redirect_to unclean_constituents_import_page_path, notice: "csv imported"
  end

  def import_page
    @nav_status = 'import_page'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_constituent
      @unclean_constituent = UncleanConstituent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def constituent_params
      params.require(:constituent).permit(:lookup_id, :suffix, :title, :name, :last_group, :email_id, :phone, :dob, :do_not_email, :duplicate,:error)
    end
end
