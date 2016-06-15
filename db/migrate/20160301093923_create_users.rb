class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      #t.string :email
      #t.string :password_hash
      #t.string :password_salt
      t.string :username
      #t.boolean :is_admin
      t.boolean :is_active
      t.date :date

      t.timestamps null: false
    end
  end
end

rake db:abort_if_pending_migrations