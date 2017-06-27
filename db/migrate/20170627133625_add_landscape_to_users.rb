class AddLandscapeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :landscape, :string
  end
end
