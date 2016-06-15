require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: { company_id: @order.company_id, end_date: @order.end_date, is_active: @order.is_active, is_closed: @order.is_closed, is_delete: @order.is_delete, start_date: @order.start_date, total_price: @order.total_price, user_id: @order.user_id, view_order_id: @order.view_order_id }
    end

    assert_redirected_to order_path(assigns(:order))
  end

  test "should show order" do
    get :show, id: @order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order
    assert_response :success
  end

  test "should update order" do
    patch :update, id: @order, order: { company_id: @order.company_id, end_date: @order.end_date, is_active: @order.is_active, is_closed: @order.is_closed, is_delete: @order.is_delete, start_date: @order.start_date, total_price: @order.total_price, user_id: @order.user_id, view_order_id: @order.view_order_id }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_redirected_to orders_path
  end
end
