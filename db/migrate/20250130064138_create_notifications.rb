class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :note
      t.references :user, foreign_key: true
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
