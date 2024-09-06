class CreateRepayments < ActiveRecord::Migration[6.1]
  def change
    create_table :repayments do |t|
      t.date :payment_date, null: false
      t.references :bill, null: false, foreign_key: true, index: true
      t.references :user, null: false, foreign_key: true, index: true
      t.string :payment_method, null: false
      t.text :notes

      t.timestamps
    end

    add_index :repayments, :payment_date
    add_index :repayments, :payment_method
  end
end
