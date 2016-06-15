require 'httparty'
require 'kitco'
class Admin::CompaniesController < Admin::BaseAdminController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_filter :initiaze_values

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
    @pt = Kitco.platinum
    @pd = Kitco.palladium
    @rh = Kitco.rhodium
    @pt = JSON.parse(@pt)
    @pd = JSON.parse(@pd)
    rescue JSON::ParserError, TypeError => e
      puts e
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    @category = Category.all
    @category.each do |category|
      @cat = Category.new(:company_id => @company.id, :name => category.name, :price => category.price, :category_id => category.id, :is_active=>1)
      @cat.save
    end
    respond_to do |format|
      if @company.save
        format.html { redirect_to admin_companies_url, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to admin_companies_url, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit}
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to admin_companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :description, :is_active, :value_troy_pt, :value_troy_pd, :value_troy_rh, :city, :state, :zip_code, :country, :address, :contact_number, :email, :stainless_steel_price)
    end

    def initiaze_values
      @pt = Kitco.platinum
      @pd = Kitco.palladium
      @rh = Kitco.rhodium
      @pt = JSON.parse(@pt)
      @pd = JSON.parse(@pd)
      rescue JSON::ParserError, TypeError => e
        puts e
    end
end
