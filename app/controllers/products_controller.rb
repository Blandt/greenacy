class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :view]
  before_filter :authenticate_user!, :only => [:show, :view]
  # GET /products
  # GET /products.json
  def index
    #@products = Product.all
    if params[:search]
              @products = Product.search(params[:search]).order("id DESC")
              #@products = Product.where(:is_active => true).paginate(:page => params[:page], per_page: 2).order('id DESC')
            else
              @products = Product.where(:is_active => true).order("created_at DESC")
            end
  end

  def addtoorder
    #@products = Product.all
    @orderToAddId = params[:id]
    if params[:search]
      @products = Product.search(params[:search]).order("id DESC")
      #@products = Product.where(:is_active => true).paginate(:page => params[:page], per_page: 2).order('id DESC')
    else
      @products = Product.where(:is_active => true).order("created_at DESC")
    end
  end

  def add_activity
    @value = params[:value]
    @search = @value
    record_activity(@search)
    respond_to do |format|
      format.json  { render :json => @search, status => "success" }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @currentUser = current_user.id
    @pt = Kitco.platinum
    @pd = Kitco.palladium
    @rh = Kitco.rhodium
    @pt = JSON.parse(@pt)
    @pd = JSON.parse(@pd)
    rescue JSON::ParserError, TypeError => e
          puts e
      if(@currentUser && @currentUser.role_id != 5)
        @userdetail = User.find(@currentUser)
        if(@userdetail.company.value_troy_pt && @userdetail.company.value_troy_pt!='')
          @value_troy_pt = @userdetail.company.value_troy_pt
        else
          @value_troy_pt = @pt.low
        end

        if(@userdetail.company.value_troy_pd && @userdetail.company.value_troy_pd!='')
          @value_troy_pd = @userdetail.company.value_troy_pd
        else
          @value_troy_pd = @pd.low
        end

        if(@userdetail.company.value_troy_rh && @userdetail.company.value_troy_rh!='')
          @value_troy_rh = @userdetail.company.value_troy_rh
        else
          @value_troy_rh = @rh.low
        end

        @assay_mat = @userdetail.assay_mat.to_f
        @weight = @product.weight.to_f
        @moisture = @product.moisture.to_f
        @pt_weight = @product.pt_weight.to_f
        @pd_weight = @product.pd_weight.to_f
        @rh_weight = @product.rh_weight.to_f

        @price_pt = ((@assay_mat*(@weight * (1 - (@moisture / 100))* 16 * 0.9114375) * (@pt_weight / 100) * @value_troy_pt.to_f ))/100
        @price_pd = ((@assay_mat*(@weight * (1 - (@moisture / 100))* 16 * 0.9114375) * (@pd_weight / 100) * @value_troy_pd.to_f ))/100
        @price_rh = ((@assay_mat*(@weight * (1 - (@moisture / 100))* 16 * 0.9114375) * (@rh_weight / 100) * @value_troy_rh.to_f ))/100
        @total_price = @price_pt+@price_pd+@price_rh+(@product.stainless_steel.to_f * @userdetail.company.stainless_steel_price.to_f)
      else
		@total_price = ''
	  end
  end

  def view

    @currentUser = current_user.id
    @pt = Kitco.platinum
    @pd = Kitco.palladium
    @rh = Kitco.rhodium
    @pt = JSON.parse(@pt)
    @pd = JSON.parse(@pd)
    rescue JSON::ParserError, TypeError => e
              puts e
    respond_to do |format|

      if(@currentUser )
        if(current_user.role_id != 5)
			@userdetail = User.find(@currentUser)
			if(@userdetail.company.value_troy_pt && @userdetail.company.value_troy_pt!='')
			  @value_troy_pt = @userdetail.company.value_troy_pt
			else
			  @value_troy_pt = @pt.low
			end

			if(@userdetail.company.value_troy_pd && @userdetail.company.value_troy_pd!='')
			  @value_troy_pd = @userdetail.company.value_troy_pd
			else
			  @value_troy_pd = @pd.low
			end

			if(@userdetail.company.value_troy_rh && @userdetail.company.value_troy_rh!='')
			  @value_troy_rh = @userdetail.company.value_troy_rh
			else
			  @value_troy_rh = @rh.low
			end

			@assay_mat = @userdetail.assay_mat.to_f
			@weight = @product.weight.to_f
			@moisture = @product.moisture.to_f
			@pt_weight = @product.pt_weight.to_f
			@pd_weight = @product.pd_weight.to_f
			@rh_weight = @product.rh_weight.to_f

			@price_pt = ((@assay_mat*(@weight * (1 - (@moisture / 100))* 16 * 0.9114375) * (@pt_weight / 100) * @value_troy_pt.to_f ))/100
			@price_pd = ((@assay_mat*(@weight * (1 - (@moisture / 100))* 16 * 0.9114375) * (@pd_weight / 100) * @value_troy_pd.to_f ))/100
			@price_rh = ((@assay_mat*(@weight * (1 - (@moisture / 100))* 16 * 0.9114375) * (@rh_weight / 100) * @value_troy_rh.to_f ))/100
			@total_price = @price_pt+@price_pd+@price_rh+(@product.stainless_steel.to_f * @userdetail.company.stainless_steel_price.to_f)

			if(@product.serial!='')
			  @total_price = @total_price
			else
			  @cat = Category.where(:category_id => @product.category_id, :company_id=>@userdetail.company_id).first
			  if(@cat)
				@total_price = @cat.price.to_f
			  else
				@caty = Category.find(:id => @product.category_id)
				@total_price = @caty.price.to_f
			  end
			end
			format.json  { render :json => { :product => @product, :total_price => @total_price }, status => "success" }
		else
			@total_price = ''
			format.json  { render :json => { :product => @product, :total_price => @total_price }, status => "success" }
		end	
      else
        @product.msg = 'You need to login first'
        format.json  { render :json => @product, status => "error" }
      end

    end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :serial, :weight, :pt_weight, :pd_weight, :rh_weight, :stainless, :moisture, :category_id, :category, :make, :model, :image_url, :image, :is_active, :total_price)
    end
end
