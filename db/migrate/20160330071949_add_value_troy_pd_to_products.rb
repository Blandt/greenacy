class AddValueTroyPdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :value_troy_pd, :string
  end
end
