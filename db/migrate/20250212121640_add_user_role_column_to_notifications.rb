class AddUserRoleColumnToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_column :notifications, :user_role, :string
  end
end
