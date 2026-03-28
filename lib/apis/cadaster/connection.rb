# typed: strict
# frozen_string_literal: true

module Apis
  module Cadaster
    class Connection
      extend T::Sig

      ParameterType = T.type_alias { T::Hash[T.any(Symbol, String), T.any(Integer, String, T::Boolean)] }

      # https://nspd.gov.ru/api/geoportal/v2/search/geoportal?thematicSearchId=2&query=90:01:100501
      BASE_HOST = "https://nspd.gov.ru"
      BASE_PATH = "/api/geoportal/v2/search/geoportal"
      CADASTER_PLOT_PATH = "/api/geoportal/v3/geoportal/36048/attrib-search"

      JSON_CONTENT_TYPE = "application/json"
      REFERER = "Referer"
      ACCEPT = "Accept"
      CONTENT_TYPE = "Content-Type"

      class Response < T::Struct
        extend T::Sig

        const :code, Integer
        const :message, String
        const :body, T::Hash[Symbol, T.untyped]

        sig { returns(T::Boolean) }
        def ok?
          code.between?(200, 299)
        end
      end

      sig { void }
      def initialize
        uri = T.cast(URI.parse(BASE_HOST), URI::HTTPS)
        @base_uri = T.let(uri, URI::HTTPS)
        @net = T.let(net(@base_uri), Net::HTTP)
      end

      sig { params(path: String, params: ParameterType).returns(Response) }
      def get(path: BASE_PATH, params: {})
        get_request = Net::HTTP::Get.new(uri(path, params).request_uri)
        get_request[ACCEPT] = JSON_CONTENT_TYPE
        get_request[REFERER] = REFERER

        response_data = Rails.cache.fetch(get_request.path, expires_in: 10.minutes) do
          response = @net.request(get_request)
          if response[CONTENT_TYPE] == JSON_CONTENT_TYPE
            response.body = JSON.parse(response.body, symbolize_names: true)
          end

          Rails.logger.info "Cadaster API response: code - #{response.code}, message - #{response.message}"
          {code: response.code, message: response.message, body: response.body}
        end

        TypeCoerce[Response].new.from(response_data)
      rescue Net::OpenTimeout => error
        TypeCoerce[Response].new.from({code: 408, message: error.message, body: {}})
      end

      sig { params(path: String, params: ParameterType, body: T::Hash[Symbol, T.untyped]).returns(Response) }
      def post(path: CADASTER_PLOT_PATH, params: {page: 0, count: 40, withTotalCount: true}, body: {})
        post_response = Net::HTTP::Post.new(uri(path, params).request_uri)
        post_response[CONTENT_TYPE] = JSON_CONTENT_TYPE
        post_response[ACCEPT] = JSON_CONTENT_TYPE
        post_response[REFERER] = REFERER
        post_response.body = JSON.generate(body)

        response = @net.request(post_response)
        if response[CONTENT_TYPE] == JSON_CONTENT_TYPE
          response.body = JSON.parse(response.body, symbolize_names: true)
        end

        TypeCoerce[Response].new.from({code: response.code, message: response.message, body: response.body})
      rescue Net::OpenTimeout => error
        TypeCoerce[Response].new.from({code: 408, message: error.message, body: {}})
      end

      private

      sig { params(uri: URI::HTTPS).returns(Net::HTTP) }
      def net(uri)
        net = Net::HTTP.new(uri.host, uri.port)

        net.use_ssl = true
        net.verify_mode = OpenSSL::SSL::VERIFY_NONE

        net.set_debug_output(Rails.logger)

        net.open_timeout = 3
        net.read_timeout = 3

        net
      end

      sig { params(path: String, params: ParameterType).returns(URI::HTTPS) }
      def uri(path, params = {})
        uri = @base_uri.dup
        uri.path = path
        uri.query = URI.encode_www_form(params)

        uri
      end
    end
  end
end
