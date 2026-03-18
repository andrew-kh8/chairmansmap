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
    end
  end
end
