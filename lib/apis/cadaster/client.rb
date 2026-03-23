# typed: strict
# frozen_string_literal: true

module Apis
  module Cadaster
    class Client
      extend T::Sig

      class RequestError < StandardError
      end

      class BadResponse < T::Struct
        const :code, Integer
        const :message, String
      end

      PLOT_SEARCH_ID = 1
      QUARTER_SEARCH_ID = 2
      CADASTER_LAYER = 36048

      CAD_PLOT_CATEGORY = 36368
      CAD_QUART_CATEGORY = 36381

      sig { returns(Connection) }
      attr_reader :connection

      sig { void }
      def initialize
        @connection = T.let(Connection.new, Connection)
      end

      sig { params(cadaster_number: String).returns(Typed::Result[Polygon, BadResponse]) }
      def get_plot(cadaster_number)
        response = connection.get(params: {thematicSearchId: PLOT_SEARCH_ID, query: cadaster_number})

        if !response.ok?
          return Typed::Failure.new(BadResponse.new(code: response.code.to_i, message: response.message))
        end

        plot = build_polygon_from_body(response.body)
        if plot.success?
          Typed::Success.new(plot.payload)
        else
          Typed::Failure.new(BadResponse.new(code: response.code.to_i, message: plot.error))
        end
      end

      sig { params(cadaster_number_pattern: String, size: Integer, page: Integer).returns(Typed::Result[PolygonList, BadResponse]) }
      def get_plots(cadaster_number_pattern, size: 40, page: 0)
        params = {page:, count: size, withTotalCount: true}
        body = {textQueryAttrib: [{keyName: "options.cad_num", value: cadaster_number_pattern}]}

        response = connection.post(params:, body:)

        if !response.ok?
          return Typed::Failure.new(BadResponse.new(code: response.code.to_i, message: response.message))
        end

        plots = build_polygons_from_body(response.body, extra_meta: {page:, count: size})
        if plots.success?
          Typed::Success.new(plots.payload)
        else
          Typed::Failure.new(BadResponse.new(code: response.code.to_i, message: plots.error))
        end
      end

      sig { params(cadaster_number: String).returns(Typed::Result[Polygon, BadResponse]) }
      def get_quarter(cadaster_number)
        response = connection.get(params: {thematicSearchId: QUARTER_SEARCH_ID, query: cadaster_number})

        if !response.ok?
          return Typed::Failure.new(BadResponse.new(code: response.code.to_i, message: response.message))
        end

        plot = build_polygon_from_body(response.body)
        if plot.success?
          Typed::Success.new(plot.payload)
        else
          Typed::Failure.new(BadResponse.new(code: response.code.to_i, message: plot.error))
        end
      end

      private

      sig { params(response_body: T::Hash[Symbol, T.untyped]).returns(Typed::Result[Polygon, String]) }
      def build_polygon_from_body(response_body)
        features = response_body.dig(:data, :features)

        return Typed::Failure.new("Response body is empty") if features.blank?
        return Typed::Failure.new("Response body contains multiple features") if features.size != 1

        Typed::Success.new(PolygonMapper.build_polygon(features.first))
      end

      sig { params(response_body: T::Hash[Symbol, T.untyped], extra_meta: T::Hash[Symbol, T.untyped]).returns(Typed::Result[PolygonList, String]) }
      def build_polygons_from_body(response_body, extra_meta: {})
        features = response_body.dig(:data, :features)
        meta = response_body[:meta].first.merge(extra_meta)

        return Typed::Failure.new("Response body is empty") if features.blank?

        Typed::Success.new(PolygonMapper.build_polygons(features, meta))
      end
    end
  end
end
