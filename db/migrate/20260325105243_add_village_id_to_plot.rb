class AddVillageIdToPlot < ActiveRecord::Migration[8.1]
  def change
    add_column :plots, :village_id, :uuid
  end
end
