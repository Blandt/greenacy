class AddAssayMatToUser < ActiveRecord::Migration
  def change
    add_column :users, :assay_mat, :string
  end
end
