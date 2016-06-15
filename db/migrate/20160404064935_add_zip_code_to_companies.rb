class AddZipCodeToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :zip_code, :string
  end
end
