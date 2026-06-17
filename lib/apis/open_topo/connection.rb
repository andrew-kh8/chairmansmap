# typed: false
# frozen_string_literal: true

require "faraday"

module Apis
  module OpenTopo
    class Connection
      def initialize(api_key = nil)
        @api_key = api_key
      end

      def build
        create_connection
      end

      private

      BASE_URL = "https://portal.opentopography.org"

      def create_connection
        Faraday.new(options, request: request_options) do |faraday|
          faraday.request :url_encoded
          faraday.response :logger
          faraday.adapter Faraday.default_adapter
        end
      end

      def options
        {
          url: BASE_URL,
          headers: headers,
          params: {API_Key: @api_key}
        }
      end

      def headers
        {
          "Accept" => "application/octet-stream",
          "User-Agent" => "Ruby on rails"
        }
      end

      def request_options
        {
          # timeout: 7 # it creates tif file, so it can be slow :(
        }
      end
    end
  end
end
