class AddStainlessSteelPriceToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :stainless_steel_price, :string
  end
end
