class OrderDetailsController < ApplicationController
  before_action :set_order_detail, only: [:show, :edit, :update, :destroy]

  # GET /order_details
  # GET /order_details.json
  def index
    @order_details = OrderDetail.all
  end

  def view
    @orders = OrderDetail.where(order_id: params[:id]).order("date DESC")
	@ordr = Order.find(params[:id])
	@usr = User.find(@ordr.user_id)
	filename = @usr.first_name.to_s+'_'+@usr.last_name.to_s+'_'+@ordr.view_order_id.to_s
	respond_to do |format|
      format.html
      #format.csv { render text: @orders.to_csv }
      format.csv do
        response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.csv"'
        render text: @orders.to_csv
      end
    end
  end

  def edit
      #ordersarel = Order.arel_table
      #Order.where(ordersarel[:is_active].eq(1).and(ordersarel[:is_closed].not_eq(current_user.id)))
      #@isAnyOrder = Order.where.not(id:params[:id]).where(is_active: '1',is_closed: '0',user_id:current_user.id)
      #@isAnyOrder = Order.where(is_active: '1',is_closed: '0',user_id:current_user.id,id:not_eq(params[:id]))
      #if(@isAnyOrder)
      #  respond_to do |format|
      #    format.html { redirect_to '/orders', notice: 'Sorry cannot edit an existing order while there is another order started.' }
      #  end
      #else
        @orders = OrderDetail.where(order_id: params[:id]).order("date DESC")
        @ordr = Order.find(params[:id])
        #@ordr.update(:id =>@ordr.id, :is_closed=>0)
      #end
  end

  def orderdetailsdelete
    @orderDetail = OrderDetail.find(params[:id])
    respond_to do |format|
      if(@orderDetail)
        @orders = Order.find(@orderDetail.order_id)
        @userBy = User.find(@orders.user_id)
        if(@orders.user_id==current_user.id || @userBy.parent_id==current_user.id)
          @quantity = @orders.quantity.to_f - @orderDetail.quantity.to_f
          @price = @orders.total_price.to_f - @orderDetail.price.to_f
          if(@quantity<0)
            @quantity = 0
          end
          if(@price<0)
            @price = 0.00
          end
          if @orders.update(:id =>@orders.id, :quantity=>@quantity, :total_price=>@price)
            @orderDetail.destroy
            format.html { redirect_to controller: 'order_details', action: 'edit', id: @orders.id, something: 'else', notice: 'Item was successfully deleted.' }
            format.json { head :no_content }
          else
            format.html { redirect_to controller: 'order_details', action: 'edit', id: @orders.id, something: 'else', notice: 'Sorry Item could not be deleted. Please try again.' }
            format.json { head :no_content }
          end
        else
          format.html { redirect_to controller: 'order_details', action: 'edit', id: @orders.id, something: 'else', notice: 'Sorry you do not have permission to delete the order.' }
          format.json { head :no_content }
        end
      else
        format.html { redirect_to '/orders', notice: 'Sorry Item was not found.' }
        format.json { head :no_content }
      end
    end
  end

  def addToCart
    @getOrder = Order.find(params[:oid])
    @getUserOfOrder = User.find(@getOrder.user_id)

    respond_to do |format|
	  if(@getUserOfOrder.id == current_user.id || @getUserOfOrder.parent_id == current_user.id )
		@vpid = params[:vpid]
		@perPrice = params[:price].to_d
		@qnt = params[:quantity].to_f
		@orderPrice = @perPrice*@qnt
		@orderPrice = @orderPrice.to_d
		#number_with_precision(@orderPrice, :precision => 2)
		@orddet = OrderDetail.where(:order_id => params[:oid], :product_id => params[:pid]).first
		if @orddet
			@op = @orddet.price.to_d
			@top = @op + @orderPrice
			@oq = @orddet.quantity.to_f
			@toq = @oq + @qnt
			@orddet.update(:id=>@orddet.id, :price=>@top, :quantity=>@toq)
			@order = Order.find(params[:oid])
			@totPrice = @order.total_price.to_d
			@total_price = @totPrice+@orderPrice
			@total_price = @total_price.to_d
			@quantity = @order.quantity.to_f+@qnt.to_f
			@order.update(:id=>@order.id, :total_price=>@total_price, :quantity=>@quantity)

			@string = "ORD0000"
            @orderId = @string + @order.id.to_s
            @value = "Product "+@vpid+" added to Order "+@orderId
            record_activity(@value)

			format.json  { render :json => @order, status => "success" }
		else
			@orderDetail = OrderDetail.new(:order_id => params[:oid], :product_id => params[:pid], :price => @orderPrice, :date =>Time.now, :quantity=>params[:quantity])
		
			if @orderDetail.save
				@order = Order.find(params[:oid])
				@totPrice = @order.total_price.to_d
				@total_price = @totPrice+@orderPrice
				@total_price = @total_price.to_d
				@quantity = @order.quantity.to_f+@qnt.to_f
				@order.update(:id=>@order.id, :total_price=>@total_price, :quantity=>@quantity)

				@string = "ORD0000"
                @orderId = @string + @order.id.to_s
                @value = "Product "+@vpid+" added to Order "+@orderId
                record_activity(@value)

				format.json  { render :json => @order, status => "success" }
			else
				format.json  { render :json => @order, status => "error" }
			end
		end
	  else
	    format.json  { render :json => @order, status => "error", message => "You donot have permission to add product to the order." }
	  end
    end
  end

  def updateCart
    respond_to do |format|
      @id = params[:id]
      @vpid = params[:vpid]
      @perPrice = params[:price].to_d
      @qnt = params[:quantity].to_f
      @orderPrice = @perPrice*@qnt
      @orderPrice = @orderPrice.to_d

      @orddet = OrderDetail.find(params[:id])
      @ord = Order.find(params[:oid])
      if @orddet

          @orddet.update(:id=>@orddet.id, :price=>@orderPrice, :quantity=>@qnt)

          @allPrice = 0.00
          @allqnt = 0.0
          @allOrderDetails = OrderDetail.where(order_id: params[:oid])
          @allOrderDetails.each do |allOrderDetail|
            @allPrice = @allPrice.to_d + allOrderDetail.price.to_d
            @allqnt = @allqnt + allOrderDetail.quantity.to_d
          end
          @ord.update(:id=>@ord.id, :total_price=>@allPrice, :quantity=>@allqnt)

          @string = "ORD0000"
            @orderId = @string + @ord.id.to_s
            @value = "Product "+@vpid+" updated to Order "+@orderId
            record_activity(@value)
          format.json  { render :json => @ord, status => "success" }
      else
          @orderDetail = OrderDetail.new(:order_id => params[:oid], :product_id => params[:pid], :price => @orderPrice, :date =>Time.now, :quantity=>params[:quantity])
          format.json  { render :json => @order, status => "error" }
      end
    end
  end

  # GET /order_details/1
  # GET /order_details/1.json
  def show
  end

  # GET /order_details/new
  def new
    @order_detail = OrderDetail.new
  end

  # GET /order_details/1/edit
  #def edit
  #end

  # POST /order_details
  # POST /order_details.json
  def create
    @order_detail = OrderDetail.new(order_detail_params)

    respond_to do |format|
      if @order_detail.save
        format.html { redirect_to @order_detail, notice: 'Order detail was successfully created.' }
        format.json { render :show, status: :created, location: @order_detail }
      else
        format.html { render :new }
        format.json { render json: @order_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_details/1
  # PATCH/PUT /order_details/1.json
  def update
    respond_to do |format|
      if @order_detail.update(order_detail_params)
        format.html { redirect_to @order_detail, notice: 'Order detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @order_detail }
      else
        format.html { render :edit }
        format.json { render json: @order_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_details/1
  # DELETE /order_details/1.json
  def destroy
    @order_detail.destroy
    respond_to do |format|
      format.html { redirect_to order_details_url, notice: 'Order detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_detail
      #@order_detail = OrderDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_detail_params
      params.require(:order_detail).permit(:order_id, :product_id, :price, :date, :quantity)
    end
end
