class AddValueTroyPtToProducts < ActiveRecord::Migration
  def change
    add_column :products, :value_troy_pt, :string
  end
end
