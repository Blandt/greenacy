class RemoveContactNumberFromCompanies < ActiveRecord::Migration
  def change
    remove_column :companies, :contact_number, :string
  end
end
