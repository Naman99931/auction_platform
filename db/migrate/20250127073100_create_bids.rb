class CreateBids < ActiveRecord::Migration[8.0]
  def change
    create_table :bids do |t|
      t.integer :amount
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
      t.boolean :final_bid, default: false
      t.timestamps
    end
  end
end
