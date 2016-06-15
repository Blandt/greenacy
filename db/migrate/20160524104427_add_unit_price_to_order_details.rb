class AddUnitPriceToOrderDetails < ActiveRecord::Migration
  def change
    add_column :order_details, :unit_price, :string
  end
end
