class AddPriceToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :price, :string
  end
end
