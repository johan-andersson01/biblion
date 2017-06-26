class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.date :year
      t.text :description
      t.text :user_description
      t.integer :swaps
      t.boolean :available
      t.string :location
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :books, [:user_id, :created_at]
  end
end
