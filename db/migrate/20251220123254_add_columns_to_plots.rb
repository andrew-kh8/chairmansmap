class AddColumnsToPlots < ActiveRecord::Migration[8.1]
  def change
    add_column :plots, :cadastral_number, :string
    add_column :plots, :description, :string
    add_column :plots, :owner_type, :string
    add_column :plots, :sale_status, :string
  end
end
