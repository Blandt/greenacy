class AddContactNumberToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :contact_number, :string
    add_index :companies, :contact_number, unique: true
  end
end
