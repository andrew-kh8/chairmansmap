# frozen_string_literal: true

require "faraday"
require "oj"

module Apis
  module Geoplys
    class Client
      class ResponseError < StandardError
      end

      BASE_URL = "https://api.roscadastres.com/"

      def self.get(path, params)
        result = connection.get(path, params)

        Oj.load result.body, symbol_keys: true
      rescue Oj::ParseError
        raise ResponseError, result.body
      end

      private_class_method

      def self.connection
        @connection ||= create_connection
      end

      def self.create_connection
        Faraday.new(options) do |faraday|
          faraday.request :url_encoded
          faraday.response :json, parser_options: {decoder: Oj, symbolize_names: true}
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
    end
  end
end
