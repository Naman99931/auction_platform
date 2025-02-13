class AddColumnToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_column :notifications, :item_id, :integer, default: nil
  end
end
