class AddValueTroyRhToProducts < ActiveRecord::Migration
  def change
    add_column :products, :value_troy_rh, :string
  end
end
