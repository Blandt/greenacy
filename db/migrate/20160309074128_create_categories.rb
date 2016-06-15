class CreateCategories < ActiveRecord::Migration
    def change
        create_table :categories, force: true do |t|
            t.belongs_to :category
            t.string :name, :null => false
            t.timestamps
        end
    end
end
