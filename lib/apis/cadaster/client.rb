# typed: strict
# frozen_string_literal: true

module Apis
  module Cadaster
    class Client
      extend T::Sig
      include Dry::Monads::Result::Mixin

      class RequestError < StandardError
      end

      class ResponseError < StandardError
      end

      PLOT_SEARCH_ID = 1
      QUARTER_SEARCH_ID = 2

      sig { returns(Connection) }
      attr_reader :connection

      sig { void }
      def initialize
        @connection = T.let(Connection.new, Connection)
      end

      sig { params(cadaster_number: String).returns(Dry::Monads::Result[Net::HTTPResponse, Plot]) }
      def get_plot(cadaster_number)
        response = connection.get(params: {thematicSearchId: PLOT_SEARCH_ID, query: cadaster_number})

        if response.is_a?(Net::HTTPSuccess)
          Success(build_plot_from_body(T.cast(response.body, T::Hash[Symbol, T.untyped])))
        else
          Failure(response)
        end
      end

      sig { params(cadaster_number: String).returns(Dry::Monads::Result[Net::HTTPResponse, Plot]) }
      def get_quarter(cadaster_number)
        response = connection.get(params: {thematicSearchId: QUARTER_SEARCH_ID, query: cadaster_number})

        if response.is_a?(Net::HTTPSuccess)
          Success(build_plot_from_body(T.cast(response.body, T::Hash[Symbol, T.untyped])))
        else
          Failure(response)
        end
      end

      private

      sig { params(response_body: T::Hash[Symbol, T.untyped]).returns(Plot) }
      def build_plot_from_body(response_body)
        features = response_body.dig(:data, :features)

        if features.blank?
          raise ResponseError, "Response body is empty"
        end

        if features.size != 1
          raise ResponseError, "Response body contains multiple features"
        end

        PlotMapper.build_plot(features.first)
      end
    end
  end
end
