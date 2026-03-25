# typed: false
# frozen_string_literal: true

module Apis
  module Agromonitoring
    class Client
      class AgromonitoringError < StandardError
        FIELD_REGEX = /("\w+")/

        attr_reader :name, :field

        def initialize(body)
          if body.key?(:name)
            @name = body[:name]
            @field = body[:message].match(FIELD_REGEX)[1]
          else
            @name = body[:title]
            @field = nil
          end
          super(body[:message])
        end
      end

      def initialize(api_key = nil)
        api_key ||= ENV.fetch("AGROMONITORING_API_KEY")
        @connection = Connection.new(api_key).build
      end

      def list_polygons
        result = @connection.get("polygons")

        result.success? ? TypeCoerce[T::Array[Polygon]].new.from(result.body) : raise(AgromonitoringError.new(result.body))
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

      sig do
        params(
          id: String,
          from: T.any(Date, Time, ActiveSupport::TimeWithZone),
          to: T.any(Date, Time, ActiveSupport::TimeWithZone)
        )
          .returns(T::Array[ImageData])
      end
      def polygon_images(id, from, to)
        result = @connection.get("image/search", {polyid: id, start: from.to_time.beginning_of_day.to_i, end: to.to_time.end_of_day.to_i})

        if result.success?
          Mappers::ToImageData.from_api(result.body)
        else
          raise(AgromonitoringError.new(result.body))
        end
      end
    end
  end
end
