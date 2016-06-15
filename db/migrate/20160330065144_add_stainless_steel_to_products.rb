class AddStainlessSteelToProducts < ActiveRecord::Migration
  def change
    add_column :products, :stainless_steel, :string
  end
end
