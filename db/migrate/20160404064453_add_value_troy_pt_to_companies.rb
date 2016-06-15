class AddValueTroyPtToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :value_troy_pt, :string
  end
end
