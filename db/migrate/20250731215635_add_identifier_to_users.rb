class AddIdentifierToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :identifier, :string, null: false
    add_index :users, :identifier, unique: true
  end
end
