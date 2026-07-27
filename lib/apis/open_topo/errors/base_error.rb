# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    module Errors
      class BaseError < StandardError
        extend T::Sig

        sig { override.params(message: T.untyped).void }
        def initialize(message = "")
          super
        end
      end
    end
  end
end
