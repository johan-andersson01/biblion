class RemoveTelephoneFromUser < ActiveRecord::Migration[5.0]
  def self.up
    remove_column :users, :telephone, :string
  end
end
