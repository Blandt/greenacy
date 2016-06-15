class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  def addnew
    @category = Category.new
  end

  def addCat
    @category = Category.new(:name => params[:name],:price => params[:price],:category_id => 0,:is_active => 1,:company_id => 0)
    respond_to do |format|
      if @category.save
        @company = Company.all
        @company.each do |company|
          @cat = Category.new(:company_id => company.id, :name => @category.name, :price => @category.price, :category_id => @category.id, :is_active=>1)
          @cat.save
        end
        format.html { redirect_to '/categories/manage', notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :addnew }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def manage
      if(current_user.role_id==4)
        @cat = Category.where(:company_id => current_user.company_id)
      else
        redirect_to '/users/manage', alert: 'Sorry you donot have permission to access.'
      end
  end

  def change
      if(current_user.role_id==4)
        @category = Category.find(params[:id])
        if(@category.company_id!=current_user.company_id)
          redirect_to :'/users/manage', alert: 'Sorry you donot have permission to access.'
        end
      else
        redirect_to :'/users/manage', alert: 'Sorry you donot have permission to access.'
      end
  end

  def changeupdate
    @category = Category.find(params[:id])
    respond_to do |format|
      if @category.update(:id=>params[:id], :price=>params[:price])
        format.html { redirect_to '/categories/manage', notice: 'Price was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :change }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
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
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
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
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
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
      params.require(:category).permit(:id, :price)
    end
end
