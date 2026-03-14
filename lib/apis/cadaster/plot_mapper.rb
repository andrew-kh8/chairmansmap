# typed: strict
# frozen_string_literal: true

module Apis
  module Cadaster
    class PlotMapper < T::Struct
      extend T::Sig

      sig { params(plots_data: T::Array[T::Hash[Symbol, T.untyped]]).returns(T::Array[Plot]) }
      def self.build_plots(plots_data)
        plots_data.map { |plot| build_plot(plot) }
      end

      sig { params(plot_data: T::Hash[Symbol, T.untyped]).returns(Plot) }
      def self.build_plot(plot_data)
        plot_data[:cadaster_number] = plot_data[:properties][:options][:cad_num] # or [:properties][:descr] / [:properties][:externalKey]
        plot_data.merge!(plot_data[:properties][:systemInfo])

        TypeCoerce[Plot].new.from(plot_data)
      end
    end
  end
end
