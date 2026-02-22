# typed: false
# frozen_string_literal: true

require "faraday"
require "oj"

module Apis
  module Cadaster
    class Client
      class RequestError < StandardError
      end

      class ResponseError < StandardError
      end

      BASE_URL = "https://api.roscadastres.com/"
      PKK_URL = "pkk_files/geo2.php"

      class << self
        def plot_coords(cadaster_number)
          result = get(PKK_URL, {cn: cadaster_number})

          DM::Success(result[:coordinates])
        rescue ResponseError, RequestError => error
          DM::Failure(error)
        end

        private

        def get(path, params)
          result = connection.get(path, params)

          Oj.load result.body, symbol_keys: true
        rescue Oj::ParseError
          raise ResponseError, result.body
        rescue Net::ReadTimeout, Faraday::TimeoutError => error
          raise RequestError, error.message
        end

        def connection
          @connection ||= create_connection
        end

        def create_connection
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

        def options
          {
            headers: headers,
            url: BASE_URL
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
end
