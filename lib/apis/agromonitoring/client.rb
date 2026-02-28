# typed: false
# frozen_string_literal: true

module Apis
  module Agromonitoring
    class Client
      class AgromonitoringError < StandardError
        FIELD_REGEX = /("\w+")/

        attr_reader :name, :field

        def initialize(body)
          @name = body[:name]
          @field = body[:message].match(FIELD_REGEX)[1]
          super(body[:message])
        end
      end

      def initialize(api_key = nil)
        api_key ||= ENV.fetch("AGROMONITORING_API_KEY")
        @connection = Connection.new(api_key).build
      end

      def list_polygons
        @connection.get("polygons").body
      end

      def polygon(id)
        result = @connection.get("polygons/#{id}")
        result.success? ? Polygon.new(**result.body) : raise(AgromonitoringError.new(result.body))
      end

      def create_polygon(name:, geo_json:)
        result = @connection.post("polygons", {name:, geo_json:})
        result.success? ? Polygon.new(**result.body) : raise(AgromonitoringError.new(result.body))
      end

      def delete_polygon(id)
        result = @connection.delete("polygons/#{id}")
        result.success? ? result.body : raise(AgromonitoringError.new(result.body))
      end

      def polygon_images(id, from, to)
        result = @connection.get("image/search", {polyid: id, start: from.to_i, end: to.to_i})

        if result.success?
          Mappers::ToImageData.from_api(result.body)
        else
          raise(AgromonitoringError.new(result.body))
        end
      end
    end
  end
end
