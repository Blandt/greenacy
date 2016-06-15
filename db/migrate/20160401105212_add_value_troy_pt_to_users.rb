class AddValueTroyPtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :value_troy_pt, :string
  end
end
