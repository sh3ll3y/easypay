class AddCreditToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :credit, :decimal, precision: 10, scale: 2, default: 0
  end
end
