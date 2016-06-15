class AddValueTroyRhToUsers < ActiveRecord::Migration
  def change
    add_column :users, :value_troy_rh, :string
  end
end
