class AddDonatedToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :donated, :boolean, default: false
  end
end
