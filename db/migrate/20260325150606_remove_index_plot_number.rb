class RemoveIndexPlotNumber < ActiveRecord::Migration[8.1]
  def change
    remove_index :plots, :number, unique: true
  end
end
