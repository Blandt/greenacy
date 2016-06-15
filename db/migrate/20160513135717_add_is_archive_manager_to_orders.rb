class AddIsArchiveManagerToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :is_archive_manager, :boolean
  end
end
