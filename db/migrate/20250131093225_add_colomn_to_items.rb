class AddColomnToItems < ActiveRecord::Migration[8.0]
  def change
    change_table :items do |t|
      t.integer :winner_id, default: nil
    end
  end
end
