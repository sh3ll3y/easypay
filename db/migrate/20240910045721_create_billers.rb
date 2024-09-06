class CreateBillers < ActiveRecord::Migration[6.1]
  def change
    create_table :billers do |t|
      t.string :name
      t.string :biller_id
      t.json :plans

      t.timestamps
    end
    add_index :billers, :biller_id, unique: true
  end
end
