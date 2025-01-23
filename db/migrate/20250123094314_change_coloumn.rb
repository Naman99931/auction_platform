class ChangeColoumn < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.change :phone_no, :bigint
    end
  end
end
