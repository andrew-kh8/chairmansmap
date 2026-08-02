# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    module Errors
      class ResponseError < BaseError
        sig { override.params(message: T.untyped).void }
        def initialize(message = "")
          super(message.is_a?(Hash) ? message["error"] || message : message)
        end
      end
    end
  end
end
