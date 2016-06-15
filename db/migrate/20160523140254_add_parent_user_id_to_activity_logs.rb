class AddParentUserIdToActivityLogs < ActiveRecord::Migration
  def change
    add_column :activity_logs, :parent_user_id, :integer
  end
end
