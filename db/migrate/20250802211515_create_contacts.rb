class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :identifier, null: false
      t.string :first_name, null: false
      t.string :last_name
      t.date :birthdate
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :contacts, :identifier, unique: true
  end
end
