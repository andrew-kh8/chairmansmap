class RenamePlotPlotDataColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :plots, :perimetr, :perimeter

    rename_column :plot_data, :kadastr_number, :cadastral_number
  end
end
