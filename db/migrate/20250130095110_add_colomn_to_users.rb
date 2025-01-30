class AddColomnToUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      # t.add_column :confirmation_token, :string
      # t.add_column :confirmed_at, :datetime
      # t.add_column :confirmation_sent_at, :datetime
      # t.add_column :unconfirmed_email, :string

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
    end
  end
end
