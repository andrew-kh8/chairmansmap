# typed: strict
# frozen_string_literal: true

module Apis
  module Cadaster
    class Client
      extend T::Sig

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

      sig { params(cadaster_number: String).returns(DM::Result) }
      def get_plot(cadaster_number)
        result = connection.get(params: {thematicSearchId: PLOT_SEARCH_ID, query: cadaster_number})

        DM::Success(result.body)
      rescue ResponseError, RequestError => error
        DM::Failure(error)
      end

      sig { params(cadaster_number: String).returns(DM::Result) }
      def get_quarter(cadaster_number)
        result = connection.get(params: {thematicSearchId: QUARTER_SEARCH_ID, query: cadaster_number})

        DM::Success(result.body)
      rescue ResponseError, RequestError => error
        DM::Failure(error)
      end
    end
  end
end
