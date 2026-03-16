# typed: strict

class PlotCoordsUpdateWorker
  extend T::Sig

  sig { params(plots: T.nilable(T::Array[Plot])).returns(T::Hash[Symbol, T.untyped]) }
  def perform(plots = nil)
    result = {success: [], failure: []}

    plots ||= Plot.all

    plots.each do |plot|
      result_plot = PlotCoordsUpdater.call(plot)

      if result_plot.success?
        result[:success] << result_plot.success
      else
        result[:failure] << result_plot.failure
      end
    end

    result
  end
end
