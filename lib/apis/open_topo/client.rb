# typed: false
# frozen_string_literal: true

module Apis
  module OpenTopo
    class Client
      API_KEY_NAME = "OPEN_TOPOGRAPHY_API_KEY"
      DEM_TYPE = "SRTMGL3"  # Available global raster datasets
      OUTPUT_FORMAT = "GTiff" # GTiff for GeoTiff, AAIGrid for Arc ASCII Grid, HFA for Erdas Imagine (.IMG)

      def initialize(api_key = nil)
        api_key ||= ENV.fetch(API_KEY_NAME)
        @connection = Connection.new(api_key).build
      end

      def globaldem(south:, north:, west:, east:, demtype: DEM_TYPE, output_format: OUTPUT_FORMAT)
        params = {
          demtype:,
          south:,
          north:,
          west:,
          east:,
          outputFormat: output_format
        }

        response = @connection.get("/API/globaldem", params)

        if response.success?
          tif_file = Apis::OpenTopo::Converters::StringToTifConverter.call(response.body, filename: filename_from_response(response))
          DemFile.new(original_file: tif_file, dem_type: demtype, output_format:)
        else
          raise Apis::OpenTopo::Errors::ResponseError, response.body
        end
      end

      private

      def filename_from_response(response)
        response.headers["Content-Disposition"].split("filename=").last.delete('"')
      end
    end
  end
end
