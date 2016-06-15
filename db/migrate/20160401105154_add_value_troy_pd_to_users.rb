class AddValueTroyPdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :value_troy_pd, :string
  end
end
