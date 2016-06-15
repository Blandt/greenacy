class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :company_id
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.string :total_price
      t.string :view_order_id
      t.boolean :is_closed
      t.boolean :is_active
      t.boolean :is_delete

      t.timestamps null: false
    end
  end
end
