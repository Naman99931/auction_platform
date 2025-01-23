class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.string :item_description
      t.integer :reserved_price
      t.integer :current_price
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
    end
  end
end
