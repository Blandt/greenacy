class AddContactNumberToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :contact_number, :string
  end
end
