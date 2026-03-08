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
          faraday.request :retry, retry_options
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

      def retry_options
        {
          max: 2,
          interval: 0.05,
          interval_randomness: 0.5,
          backoff_factor: 2,
          methods: [:get],
          exceptions: [Faraday::ConnectionFailed]
        }
      end
    end
  end
end
