class AddValueTroyToProducts < ActiveRecord::Migration
  def change
    add_column :products, :value_troy, :string
  end
end
