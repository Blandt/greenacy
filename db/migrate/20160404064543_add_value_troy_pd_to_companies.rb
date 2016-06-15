class AddValueTroyPdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :value_troy_pd, :string
  end
end
