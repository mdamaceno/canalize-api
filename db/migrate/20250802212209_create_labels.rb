class CreateLabels < ActiveRecord::Migration[8.0]
  def change
    create_table :labels do |t|
      t.string :identifier, null: false
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :labels, :identifier, unique: true
  end
end
