class AddColumnToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :flagged, :boolean, default: false
    add_column :items, :flagged, :boolean, default: false
    add_column :comments, :flagged, :boolean, default: false
  end
end
