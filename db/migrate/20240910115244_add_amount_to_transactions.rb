class AddAmountToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :amount, :decimal, precision: 10, scale: 2, null: false
  end
end
