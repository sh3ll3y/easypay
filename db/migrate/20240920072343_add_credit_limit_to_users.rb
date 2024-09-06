class AddCreditLimitToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :credit_limit, :decimal, precision: 10, scale: 2, default: 1000000.0
  end
end
