# typed: strict
# frozen_string_literal: true

module Apis
  module Agromonitoring
    module Mappers
      class ToImageData
        class << self
          extend T::Sig

          sig { params(json_data: T::Array[T::Hash[Symbol, T.untyped]]).returns(T::Array[Apis::Agromonitoring::ImageData]) }
          def from_api(json_data)
            json_data.map { |json| build_image_date(json) }
          end

          private

          sig { params(json_data: T::Hash[Symbol, T.untyped]).returns(Apis::Agromonitoring::ImageData) }
          def build_image_date(json_data)
            date = Time.zone.at(json_data[:dt])
            satellite = json_data[:type]
            valid_data_coverage = json_data[:dc].to_f
            cloud_coverage = json_data[:cl].to_f

            image = ImageData::Images.new(json_data[:image])
            tile = ImageData::Images.new(json_data[:tile])
            stats = ImageData::Images.new(json_data[:stats])
            data = ImageData::Images.new(json_data[:data])

            ImageData.new(date:, satellite:, valid_data_coverage:, cloud_coverage:, image:, tile:, stats:, data:)
          end
        end
      end
    end
  end
end
