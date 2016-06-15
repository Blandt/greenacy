class AddStainlessSteelPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :stainless_steel_price, :string
  end
end
