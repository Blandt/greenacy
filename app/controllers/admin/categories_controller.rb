class Admin::CategoriesController < Admin::BaseAdminController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    #@categories = Category.where(:company_id => '0')
     @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
    #@category = Category.find(params[:id])
    # Grab all sub-categories
    #@categories = @category.subcategories
    # We want to reuse the index renderer:
    #render :action => :index
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    #@category = Category.new(params[:category].permit!)
    #        if @category.save
    #            redirect_to categories_url
    #        else
    #            render :new
    #        end
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        @company = Company.all
        @company.each do |company|
          @cat = Category.new(:company_id => company.id, :name => @category.name, :price => @category.price, :category_id => @category.id, :is_active=>1)
          @cat.save
        end
        format.html { redirect_to admin_categories_url, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to admin_categories_url, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @categories = Category.where(:category_id => params[:id])
    @categories.each do |categories|
      categories.destroy
    end
    @category.destroy
    respond_to do |format|
      format.html { redirect_to admin_categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :category_id, :is_active, :price, :company_id)
    end
end
