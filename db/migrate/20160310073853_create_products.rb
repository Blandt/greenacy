class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :serial
      t.string :weight
      t.string :pt_weight
      t.string :pd_weight
      t.string :rh_weight
      t.string :stainless
      t.string :moisture
      t.integer :category_id
      t.string :category
      t.string :make
      t.string :model
      t.string :image_url

      t.timestamps null: false
    end
  end
end
