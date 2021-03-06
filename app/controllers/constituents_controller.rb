class ConstituentsController < ApplicationController

  before_action :set_constituent, only: [:show]
  before_action :check_login


  # GET /constituents
  # GET /constituents.json
  def index
    @nav_status = 'db'
    @constituents = Constituent.all.paginate(:page => params[:page], :per_page => 30)
    @q = Constituent.ransack(params[:q])
    @result = @q.result(distinct: true)
  end

  def search
    @q = "%#{params[:query]}"
  end

  def index_individuals
    @nav_status = 'db'
    @constituents = Constituent.individuals.paginate(:page => params[:page], :per_page => 30)
    @q = Constituent.ransack(params[:q])
    @result = @q.result(distinct: true)
  end

  def index_households
    @nav_status = 'db'
    @constituents = Constituent.households.paginate(:page => params[:page], :per_page => 30)
    @q = Constituent.ransack(params[:q])
    @result = @q.result(distinct: true)
  end

  def index_organizations
    @nav_status = 'db'
    @constituents = Constituent.organizations.paginate(:page => params[:page], :per_page => 30)
    @q = Constituent.ransack(params[:q])
    @result = @q.result(distinct: true)
  end

  # GET /constituents/1
  # GET /constituents/1.json
  def show
    @nav_status = 'db'
  end

  # GET /constituents/new
  def new
    @nav_status = 'db'
    @constituent = Constituent.new
  end

  # GET /constituents/1/edit
  def edit
    @nav_status = 'db'
  end

  # POST /constituents
  # POST /constituents.json
  def create
    @nav_status = 'db'
    @constituent = Constituent.new(constituent_params)

    respond_to do |format|
      if @constituent.save
        format.html { redirect_to @constituent, notice: 'Constituent was successfully created.' }
        format.json { render :show, status: :created, location: @constituent }
      else
        format.html { render :new }
        format.json { render json: @constituent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /constituents/1
  # PATCH/PUT /constituents/1.json
  def update
    @nav_status = 'db'
    respond_to do |format|
      if @constituent.update(constituent_params)
        format.html { redirect_to @constituent, notice: 'Constituent was successfully updated.' }
        format.json { render :show, status: :ok, location: @constituent }
      else
        format.html { render :edit }
        format.json { render json: @constituent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /constituents/1
  # DELETE /constituents/1.json
  def destroy
    @constituent.destroy
    respond_to do |format|
      format.html { redirect_to constituents_url, notice: 'Constituent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # def import
  #   Constituent.import(params[:file])
  #   redirect_to constituents_path, notice: "csv imported"
  # end

  def importfile
    Constituent.import_file(params[:file])
    redirect_to constituents_import_page_path, notice: "csv imported"
  end

  def import_page
    @nav_status = 'import_page'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_constituent
      @constituent = Constituent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def constituent_params
      params.require(:constituent).permit(:lookup_id, :suffix, :title, :name, :last_group, :email_id, :phone, :dob, :do_not_email, :duplicate)
    end
end
