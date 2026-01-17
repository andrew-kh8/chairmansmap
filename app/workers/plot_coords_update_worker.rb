class PlotCoordsUpdateWorker
  def perform(plots)
    coord_getter = Apis::Geoplys::GetCoords.new
    result = {success: [], failure: []}

    plots.each do |plot|
      cn = plot.cadastral_number

      coords = coord_getter.call(cn)
      if coords.failure?
        result[:failure] << coords.failure
        next
      end

      result_plot = PlotCoordsUpdater.new.call(cn, coords.success)

      if result_plot.success?
        result[:success] << result_plot.success
      else
        result[:failure] << result_plot.failure
      end
    end

    result
  end
end
