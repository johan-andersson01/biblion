class AddLangToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :language, :string
  end
end
