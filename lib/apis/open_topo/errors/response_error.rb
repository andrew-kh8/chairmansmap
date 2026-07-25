# typed: false
# frozen_string_literal: true

module Apis
  module OpenTopo
    module Errors
      class ResponseError < StandardError
        def initialize(message)
          super(message["error"] || message)
        end
      end
    end
  end
end
