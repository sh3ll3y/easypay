class CreateDownloads < ActiveRecord::Migration[6.1]
  def change
    create_table :downloads do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0
      t.string :file_url

      t.timestamps
    end
  end
end
