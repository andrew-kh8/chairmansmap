class AddUniqIndexToPlotData < ActiveRecord::Migration[7.0]
  def change
    add_index :plot_data, :cadastral_number, unique: true
  end
end
