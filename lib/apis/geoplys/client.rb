# frozen_string_literal: true

require "faraday"
require "oj"

module Apis
  module Geoplys
    class Client
      class RequestError < StandardError
      end

      class ResponseError < StandardError
      end

      BASE_URL = "https://api.roscadastres.com/"

      def self.get(path, params)
        result = connection.get(path, params)

        Oj.load result.body, symbol_keys: true
      rescue Oj::ParseError
        raise ResponseError, result.body
      rescue Net::ReadTimeout, Faraday::TimeoutError => error
        raise RequestError, error.message
      end

      private_class_method

      def self.connection
        @connection ||= create_connection
      end

      def self.create_connection
        Faraday.new(options, request: request_options) do |faraday|
          faraday.use :http_cache, store: Rails.cache
          faraday.request :retry, retry_options
          faraday.response :logger
          faraday.request :url_encoded
          # response has html content-type, but it's json
          # faraday.response :json, parser_options: {decoder: Oj, symbol_keys: true}, content_type: /\b(json|html)$/
          faraday.adapter Faraday.default_adapter
        end
      end

      def self.options
        {
          headers: headers,
          url: BASE_URL
        }
      end

      def self.headers
        {
          "Accept" => "application/json",
          "User-Agent" => "Ruby on rails"
        }
      end

      def self.request_options
        {
          timeout: 2
        }
      end

      def self.retry_options
        {
          max: 2,
          interval: 0.05,
          interval_randomness: 0.5,
          retry_statuses: [200],
          methods: [],
          # backoff_factor: 2,
          retry_if: ->(resp, _exc) {
            resp.body.is_a?(String) && !resp.body.starts_with?("{")
          }
        }
      end
    end
  end
end
