class AddValueTroyRhToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :value_troy_rh, :string
  end
end
