# typed: false
# frozen_string_literal: true

require "faraday"
require "oj"

module Apis
  module Agromonitoring
    class Connection
      def initialize(api_key = nil)
        @api_key = api_key
      end

      def build
        create_connection
      end

      private

      BASE_URL = "http://api.agromonitoring.com/agro/1.0/"

      def create_connection
        Faraday.new(options, request: request_options) do |faraday|
          faraday.use :http_cache, store: Rails.cache
          faraday.request :json
          faraday.response :logger
          faraday.response :json, parser_options: {decoder: Oj, symbol_keys: true}
          faraday.adapter Faraday.default_adapter
        end
      end

      def options
        {
          url: BASE_URL,
          headers: headers,
          params: {appid: @api_key}
        }
      end

      def headers
        {
          "Accept" => "application/json",
          "User-Agent" => "Ruby on rails"
        }
      end

      def request_options
        {
          timeout: 2
        }
      end
    end
  end
end
