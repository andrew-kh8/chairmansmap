class AddPlotUuidToPlotData < ActiveRecord::Migration[7.0]
  def change
    add_column :plot_data, :new_plot_id, :uuid
    add_column :owners, :new_plot_id, :uuid
  end
end
