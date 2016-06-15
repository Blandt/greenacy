class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :setmarket, :market]

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  def startOrderNewCompany
    @company = Company.new(:name => params[:name], :email => params[:email],  :city => params[:city], :state => params[:state], :address => params[:address], :zip_code => params[:zip_code], :contact_number => params[:contact_number], :is_active => 0)
    respond_to do |format|
      if @company.save
        @category = Category.all
        @category.each do |category|
          @cat = Category.new(:company_id => @company.id, :name => category.name, :price => category.price, :category_id => category.id, :is_active=>1)
          @cat.save
        end
        format.json  { render :json => @company, status => "success" }
      else
        format.json  { render :json => @order, status => "error" }
      end
    end
  end

  def checkCompany
    @companies = Company.where(contact_number:params[:contact_number])
    respond_to do |format|
      format.json  { render :json => @companies }
    end
  end

  def market
    respond_to do |format|
      if(current_user.role_id==4)
        format.html {@company = Company.find(current_user.company_id)}
      else
        format.html {redirect_to action:'index', alert: 'Sorry you donot have permission to access.'}
      end
    end
    @pt = Kitco.platinum
    @pd = Kitco.palladium
    @rh = Kitco.rhodium
    @pt = JSON.parse(@pt)
    @pd = JSON.parse(@pd)
    rescue JSON::ParserError, TypeError => e
      puts e
  end

  def setmarket
    respond_to do |format|
      if(current_user.role_id==4)
        if @company.update(company_params)
          format.html { redirect_to '/companies/market', notice: 'Changes saved successfully.' }
          format.json { render :show, status: :ok, location: @company }
        else
          format.html { redirect_to '/companies/market', notice: 'Sorry could not save the changes. Please try again.' }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to '/companies/market', notice: 'Sorry you do not have permission to save the changes.' }
      end
    end
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
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
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
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      if(current_user.company_id)
        @company = Company.find(current_user.company_id)
      else
        @company = Company.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:id, :value_troy_pt, :value_troy_pd, :value_troy_rh, :stainless_steel_price, :contact_number)
    end
end
