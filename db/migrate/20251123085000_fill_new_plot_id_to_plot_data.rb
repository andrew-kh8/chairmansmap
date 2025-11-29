class FillNewPlotIdToPlotData < ActiveRecord::Migration[7.0]
  def up
    PlotDatum.unscoped.find_each do |plot_data|
      plot_data.update(new_plot_id: Plot.find_by(number: plot_data.plot_id).attributes["id"])
    end

    Owner.unscoped.find_each do |owner|
      owner.update(new_plot_id: Plot.find_by(number: owner.plot_id).attributes["id"])
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
