class ChangeQuantityColumnToDecimal < ActiveRecord::Migration
  def change
	change_column :orders, :quantity, :decimal, :precision => 12, :scale => 1
  end
end
