class CreateBuildings < ActiveRecord::Migration[6.1]
  def change
    create_table :buildings do |t|
      t.string :name

      t.timestamps
    end
    add_index :buildings, :name
  end
end
