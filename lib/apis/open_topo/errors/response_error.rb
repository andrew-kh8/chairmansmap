# typed: false
# frozen_string_literal: true

module Apis
  module OpenTopo
    class ResponseError < StandardError
      def initialize(message)
        super(message["error"] || message)
      end
    end
  end
end
