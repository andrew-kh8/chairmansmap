class AddCadastralNumberUniqueIndexToPlot < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :plots, :cadastral_number, unique: true, algorithm: :concurrently
  end
end
