# typed: false
# frozen_string_literal: true

module Apis
  module Agromonitoring
    class Client
      def initialize(api_key = nil)
        api_key ||= ENV.fetch("AGROMONITORING_API_KEY")
        @connection = Connection.new(api_key).build
      end

      def list_polygons
        @connection.get("polygons").body
      end

      def polygon(id)
        @connection.get("polygons/#{id}").body
      end

      def create_polygon(name:, geo_json:)
        @connection.post("polygons", {name:, geo_json:}).body
      end
    end
  end
end
