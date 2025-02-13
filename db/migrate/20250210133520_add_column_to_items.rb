class AddColumnToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :payment_status, :string, default: "pending"
  end
end
