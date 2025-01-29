class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
      t.belongs_to :reply, foreign_key: {to_table: :comments}
      t.boolean :pinned, default: false
      t.timestamps
    end
  end
end
