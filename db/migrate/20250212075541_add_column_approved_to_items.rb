class AddColumnApprovedToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :approved, :boolean, default: false
  end
end
