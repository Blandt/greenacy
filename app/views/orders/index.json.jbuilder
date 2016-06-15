json.array!(@orders) do |order|
  json.extract! order, :id, :company_id, :user_id, :start_date, :end_date, :total_price, :view_order_id, :is_closed, :is_active, :is_delete
  json.url order_url(order, format: :json)
end
