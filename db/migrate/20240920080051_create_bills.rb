class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.decimal :bill_amount, precision: 10, scale: 2, null: false
      t.date :bill_date, null: false
      t.date :due_date, null: false
      t.string :status, null: false, default: 'pending'
      t.references :user, null: false, foreign_key: true, index: true
      t.string :description
      t.datetime :paid_at

      t.timestamps
    end

    add_index :bills, :status
    add_index :bills, :bill_date
    add_index :bills, :due_date
  end
end
