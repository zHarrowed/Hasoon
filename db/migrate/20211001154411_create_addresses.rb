class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :street_name, null: false
      t.string :street_number, null: false
      t.references :building, index: true, force: true, null: false

      t.timestamps
    end

    add_index :addresses, %i[street_name street_number], unique: true
  end
end
