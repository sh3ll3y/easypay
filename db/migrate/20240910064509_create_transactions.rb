class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :txn_id, null: false
      t.references :user, null: false, foreign_key: true
      t.references :biller, null: false, foreign_key: true
      t.string :mobile_number, null:false
      t.json :plan, null:false
      t.string :status, null:false

      t.timestamps
    end
    add_index :transactions, :txn_id, unique: true
    add_index :transactions, :status
  end
end
