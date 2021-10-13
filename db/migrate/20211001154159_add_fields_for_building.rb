class AddFieldsForBuilding < ActiveRecord::Migration[6.1]
  def change
    add_column :buildings, :quarter, :string, null: false
    add_column :buildings, :slug, :string, null: false
  end
end
