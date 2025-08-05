class CreatePhoneNumbers < ActiveRecord::Migration[8.0]
  def change
    create_table :phone_numbers do |t|
      t.integer :country_code, null: false
      t.string :main, null: false
      t.references :contact, null: false, foreign_key: true
      t.references :label, foreign_key: true

      t.timestamps
    end

    add_index :phone_numbers, [:country_code, :main, :contact_id], unique: true
  end
end
