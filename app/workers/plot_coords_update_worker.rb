module Workers
  class PlotCoordsUpdateWorker
    def perform(plots)
      coord_getter = Apis::Geoplys::GetCoords.new
      result = {success: [], failure: []}

      plots.each do |plot|
        cn = plot.plot_datum.cadastral_number

        coords = coord_getter.call(cn)
        if coords.failure?
          result[:failure] << coords.failure
          next
        end

        r = PlotCoordsUpdater.new.call(cn, coords.success)

        if r.success?
          result[:success] << r.success
        else
          result[:failure] << r.failure
        end
      end

      result
    end
  end
end
