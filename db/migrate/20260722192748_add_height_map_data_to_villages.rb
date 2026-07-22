class AddHeightMapDataToVillages < ActiveRecord::Migration[8.1]
  def change
    add_column :villages, :height_map_data, :jsonb
  end
end
