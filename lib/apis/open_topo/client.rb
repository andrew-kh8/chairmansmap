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
          outputFormat:
        }

        @connection.get("/API/globaldem", params)
      end
    end
  end
end
