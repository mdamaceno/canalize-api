class CreateEmailAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :email_addresses do |t|
      t.string :email, null: false
      t.references :contact, null: false, foreign_key: true
      t.references :label, foreign_key: true

      t.timestamps
    end

    add_index :email_addresses, [:email, :contact_id], unique: true
  end
end
