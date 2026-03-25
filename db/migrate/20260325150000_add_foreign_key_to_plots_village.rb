class AddForeignKeyToPlotsVillage < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_foreign_key :plots, :villages, on_delete: :cascade, validate: false
    add_index :plots, :village_id, algorithm: :concurrently
  end
end
