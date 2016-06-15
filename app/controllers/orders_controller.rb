class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
	#Order.update_all({ :is_archive_manager => false })
    if(current_user.role_id==4)
		@orders = Order.where(is_active: 1,user_id: current_user.id,is_delete: 0,is_archive_manager: 0).order("view_order_id DESC")
	else
		@orders = Order.where(is_active: 1,user_id: current_user.id,is_delete: 0).order("view_order_id DESC")
	end
  end

  def myarchivelist
	if(current_user.role_id==4)
		@orders = Order.where(is_active: 1,user_id: current_user.id,is_delete: 0,is_archive_manager: 1).order("view_order_id DESC")
	else
		@orders = Order.where(is_active: 1,user_id: current_user.id,is_delete: 0).order("view_order_id DESC")
	end
  end

  def archiveeach
  	respond_to do |format|
  		if(current_user.role_id==4)
  			@orders = Order.find(params[:id])
  			@users = User.find(@orders.user_id)
  			if(@users.id == current_user.id)
  			  @url = '/orders'
  			else
  			  @url = '/orders/team/'+@users.id.to_s
  			end
  			if( @users.id == current_user.id || @users.parent_id == current_user.id )
              if(@orders.is_closed==true)
                @orders.update(:id=>params[:id], :is_archive_manager=>true)

                format.html { redirect_to @url, notice: 'Order archived successfully.' }
                format.json { head :no_content }
              else
                format.html {redirect_to @url, notice: 'Sorry open order cannot be archived.'}
                format.json { head :no_content }
              end
  			else
              format.html {redirect_to @url, notice: 'Sorry you do not have permission.'}
              format.json { head :no_content }
  			end
  		else
  			format.html {redirect_to @url, notice: 'Sorry you donot have permission.'}
  			format.json { head :no_content }
  		end
  	end
  end

  def archive
	respond_to do |format|
		if(current_user.role_id==4)
			@users = User.where(is_active: '1',role_id: '1',parent_id:current_user.id).order("first_name DESC")
			@users.each do |user|
			  @orders = Order.where(is_active: 1,user_id: user.id,is_delete: 0,is_closed: 1)
			  @orders.each do |order|
				#Order.update(:id=>order.id, :is_archive_manager=>true)
				order.update(:id=>order.id, :is_archive_manager=>true)
			  end
			end
			@orders = Order.where(is_active: 1,user_id: current_user.id,is_delete: 0,is_closed: 1)
			@orders.each do |order|
			  #Order.update(:id=>order.id, :is_archive_manager=>true)
			  order.update(:id=>order.id, :is_archive_manager=>true)
			end
			format.html { redirect_to '/users/manage', notice: 'All orders archived successfully.' }
			format.json { head :no_content }
		else
			format.html {redirect_to action:'index', alert: 'Sorry you donot have permission to access.'}
		end
	end
  end	

  def archivelist
    @orders = Order.where(is_active: 1,user_id: params[:id],is_delete: 0,is_archive_manager:true).order("view_order_id DESC")
	respond_to do |format|
      format.html
      format.csv { render text: @orders.to_csv }
    end
	#@ordr = Order.find(params[:id])
  end

  def team
    @orders = Order.where(is_active: 1,user_id: params[:id],is_delete: 0,is_archive_manager: false,is_closed: 1 ).order("view_order_id DESC")
	respond_to do |format|
      format.html
      format.csv { render text: @orders.to_csv }
    end
	#@ordr = Order.find(params[:id])
  end

  def startorder
    #appKontroller = ApplicationController.new
    #appKontroller.send(:check_order)

    respond_to do |format|
      @ordr = Order.find(params[:id])
      @users = User.find(@ordr.user_id)

      if(@users.id == current_user.id)
        @url = '/orders'
      else
        @url = '/orders/team/'+@users.id.to_s
      end

      if( @users.id == current_user.id || @users.parent_id == current_user.id )

        if(current_user)
          @isOrderForSatrt = Order.where(is_active: '1',is_closed: '0',user_id:current_user.id).first
          if(!@isOrderForSatrt)
            if(current_user.role_id==4)
              @userOfManagers = User.where(parent_id:current_user.id)
              @userOfManagers.each do |userOfManager|
                @isOrderForSatrt = Order.where(is_active: '1',is_closed: '0',user_id:userOfManager.id).first
              end
            end
          end
        end

        if(@isOrderForSatrt)
          format.html { redirect_to '/order_details/edit/'+@ordr.id.to_s, notice: 'Sorry cannot open an order untill your old order is closed. .' }
          format.json { head :no_content }
        else
          @ordr.update(:id =>@ordr.id, :is_closed=>0)
          format.html { redirect_to '/order_details/edit/'+@ordr.id.to_s, notice: 'Order started successfully.' }
          format.json { head :no_content }
        end

        #@ordr.update(:id =>@ordr.id, :is_closed=>0)
        #format.html { redirect_to '/order_details/edit/'+@ordr.id.to_s, notice: 'Order started successfully.' }
        #format.json { head :no_content }
      else
        format.html {redirect_to @url, notice: 'Sorry you do not have permission.'}
        format.json { head :no_content }
      end
    end
  end

  def startOrderExistCompany
    @order = Order.new(:company_id => params[:company_id], :user_id => current_user.id, :start_date => Time.now,  :total_price => 0, :is_archive_manager=>0, :is_closed => 0, :is_active => 1, :is_delete => 0, :quantity => 0)
    respond_to do |format|
      if @order.save
        @string = "ORD0000"
        @orderId = @string + @order.id.to_s
        @order.update(:id=>@order.id, :view_order_id=>@orderId)
        @value = "Started order "+@orderId
        record_activity(@value)
        format.json  { render :json => @order, status => "success" }
      else
        format.json  { render :json => @order, status => "error" }
      end
    end
  end

  def orderdelete
    @orders = Order.find(params[:id])
    @userOrders = User.find(@orders.user_id)
    if(@userOrders.id == current_user.id)
      @url = '/orders'
    else
      @url = '/orders/team/'+@userOrders.id.to_s
    end
    respond_to do |format|
      if(@orders)
        if(@orders.user_id==current_user.id || @userOrders.parent_id == current_user.id )
          @orders.destroy
          @string = "ORD0000"
          @orderId = @string + params[:id].to_s
          @value = "Order "+@orderId + " was deleted"
          record_activity(@value)

          format.html { redirect_to @url, notice: 'Order was successfully destroyed.' }
          format.json { head :no_content }
        else
          format.html { redirect_to @url, notice: 'Sorry you donot have permission to delete the order.' }
          format.json { head :no_content }
        end
      else
        format.html { redirect_to @url, notice: 'Sorry Order was not found.' }
        format.json { head :no_content }
      end
    end
  end

  def orderclose
      @orders = Order.find(params[:id])
      @userByOrders = User.find(@orders.user_id)
      respond_to do |format|
        if(@orders)
          if(@orders.user_id==current_user.id || @userByOrders.parent_id==current_user.id)
            if(@orders.quantity>0)
              @orders.update(:id=>@orders.id,:is_closed=>1)
              @string = "ORD0000"
              @orderId = @string + @orders.id.to_s
              @value = "Order "+@orderId + " was closed"
              record_activity(@value)
              format.html { redirect_to '/orders', notice: 'Order was successfully Closed.' }
              format.json { head :no_content }
            else
              @string = "ORD0000"
              @orderId = @string + @orders.id.to_s
              @value = "Order "+@orderId + " was deleted"
              record_activity(@value)
              @orders.destroy

              format.html { redirect_to '/orders', notice: 'Order was successfully deleted as no item was there in the order.' }
              format.json { head :no_content }
            end
          else
            format.html { redirect_to '/orders', notice: 'Sorry you donot have permission to delete the order.' }
            format.json { head :no_content }
          end
        else
          format.html { redirect_to '/orders', notice: 'Sorry Order was not found.' }
          format.json { head :no_content }
        end
      end
    end



  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:company_id, :user_id, :start_date, :end_date, :total_price, :view_order_id, :is_closed, :is_active, :is_delete, :quantity, :is_archive_manager)
    end
end
