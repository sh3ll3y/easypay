class AddDeletedAtToUsersAndBillers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :deleted_at, :datetime
    add_column :billers, :deleted_at, :datetime

    # Add indexes for better query performance
    add_index :users, :deleted_at
    add_index :billers, :deleted_at
  end
end
