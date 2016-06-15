class AddAssayMatToProducts < ActiveRecord::Migration
  def change
    add_column :products, :assay_mat, :string
  end
end
